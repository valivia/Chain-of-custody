import { Body, Controller, Delete, ForbiddenException, Get, NotFoundException, Param, Patch, Post, Req } from '@nestjs/common';
import { Case, CaseStatus, CaseUser, MediaEvidence, TaggedEvidence, User as PrismaUser, Action } from "@prisma/client";
import { IsEnum, IsOptional, IsString } from "class-validator";
import { User, UserEntity } from "src/guards/auth.guard";
import { PrismaService } from 'src/services/prisma.service';
import { checkCaseVisibility, CasePermission, getAllCasePermissions } from "./permissions";
import { Request } from "express";
import { saveToAuditLog } from "src/util/auditlog";
import { rm } from "fs/promises";
import { userToCaseUser } from "./user/case_user.controller";

class CaseDto {
  @IsString()
  title: string;

  @IsString()
  description: string;
}

class CaseUpdateDto {
  @IsOptional()
  @IsString()
  title: string;

  @IsOptional()
  @IsString()
  description: string;

  @IsOptional()
  @IsString()
  @IsEnum(CaseStatus)
  status: CaseStatus;
}

interface CaseUserData {
  userId: string;
  firstName: string;
  lastName: string;
  email: string;
  permissions: string;
}

type CaseData = Case & { users: CaseUserData[], mediaEvidence: MediaEvidence[], taggedEvidence: TaggedEvidence[] };

const caseSelector = {
  auditLog: { where: { mediaEvidenceId: null, taggedEvidenceId: null } },
  users: { include: { auditLog: true, user: true } },
  taggedEvidence: { include: { auditLog: true } },
  mediaEvidence: { include: { auditLog: true } },

}

@Controller('case')
export class CaseController {
  constructor(private readonly prisma: PrismaService) { }

  private caseToCaseData(data: Case & { users: (CaseUser & { user: PrismaUser })[], mediaEvidence: MediaEvidence[], taggedEvidence: TaggedEvidence[] }): CaseData {
    return {
      ...data,
      users: data.users.map(userToCaseUser),
    }
  }

  @Get()
  async findAll(@User() user: UserEntity) {
    const cases = await this.prisma.case.findMany({
      where: {
        users: {
          some: {
            userId: user.id
          }
        }
      },
      include: caseSelector,
      orderBy: {
        createdAt: 'desc'
      }
    }).then(cases =>
      cases.filter(entry =>
        entry.users.find(u => u.userId === user.id)?.hasPermission(CasePermission.view)
      )
    );

    const data = cases
      .map(this.caseToCaseData)
      .sort((a, b) => {
        type Item = { createdAt: Date };

        const aDate = ([] as Item[])
          .concat(a.taggedEvidence)
          .concat(a.mediaEvidence)
          .sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime())[0]
          ?.createdAt ?? a.createdAt;

        const bDate = ([] as Item[])
          .concat(b.taggedEvidence)
          .concat(b.mediaEvidence)
          .sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime())[0]
          ?.createdAt ?? b.createdAt;

        return bDate.getTime() - aDate.getTime();
      });

    return { data };
  }

  @Get(':id')
  async findOne(@Param('id') id: string, @User() user: UserEntity) {
    await checkCaseVisibility(this.prisma, id, user.id);

    const data = await this.prisma.case.findUnique({
      where: { id },
      include: caseSelector,
    });

    if (!data) {
      throw new NotFoundException();
    }

    return { data };
  }

  @Post()
  async create(@Req() req: Request, @User() user: UserEntity, @Body() caseData: CaseDto) {

    const createdCase = await this.prisma.case.create({
      data: {
        ...caseData,
        users: {
          createMany: {
            data: [
              {
                userId: user.id,
                permissions: getAllCasePermissions().toString(2)
              }
            ]
          }
        }
      },
      include: caseSelector,
    });

    await saveToAuditLog(this.prisma, req, {
      action: Action.create,
      newData: createdCase,
      userId: user.id,
      caseId: createdCase.id,
    });

    return { data: this.caseToCaseData(createdCase) };
  }

  @Patch(':id')
  async update(@Req() req: Request, @Param('id') id: string, @User() user: UserEntity, @Body() caseData: CaseUpdateDto) {
    const caseUser = await checkCaseVisibility(this.prisma, id, user.id);

    if (!caseUser.hasPermission(CasePermission.manage)) {
      throw new ForbiddenException("Permission denied");
    }

    const updatedCase = await this.prisma.case.update({
      where: { id },
      data: caseData,
    });

    await saveToAuditLog(this.prisma, req, {
      action: Action.update,
      oldData: caseUser.case,
      newData: updatedCase,
      userId: user.id,
      caseId: id,
    });

    return { data: updatedCase };
  }

  @Delete(':id')
  async delete(@Req() req: Request, @Param('id') id: string, @User() user: UserEntity) {
    const caseUser = await checkCaseVisibility(this.prisma, id, user.id);

    if (!caseUser.hasPermission(CasePermission.manage)) {
      throw new ForbiddenException("Permission denied");
    }

    await saveToAuditLog(this.prisma, req, {
      action: Action.delete,
      oldData: caseUser.case,
      userId: user.id,
      caseId: id,
    });

    const deletedCase = await this.prisma.case.delete({
      where: { id },
      include: {
        mediaEvidence: true,
      }
    });

    const deleteQueue = deletedCase.mediaEvidence.map(async media => {
      return rm(`./data/evidence/${media.id}.jpg`);
    });

    await Promise.allSettled(deleteQueue);

    console.log("Deleted ", deleteQueue.length, " files");

    return { data: null };
  }
}
