import { Body, Controller, ForbiddenException, Get, NotFoundException, Param, Patch, Post } from '@nestjs/common';
import { Case, CaseStatus, CaseUser, MediaEvidence, TaggedEvidence, User as PrismaUser } from "@prisma/client";
import { IsEnum, IsOptional, IsString } from "class-validator";
import { User, UserEntity } from "src/guards/auth.guard";
import { PrismaService } from 'src/services/prisma.service';
import { checkCaseVisibility, CasePermission, getAllCasePermissions } from "./permissions";

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

@Controller('case')
export class CaseController {
  constructor(private readonly prisma: PrismaService) { }

  private caseToCaseData(data: Case & { users: (CaseUser & { user: PrismaUser })[], mediaEvidence: MediaEvidence[], taggedEvidence: TaggedEvidence[] }): CaseData {
    return {
      ...data,
      users: data.users.map(u => {
        return {
          userId: u.userId,
          firstName: u.user.firstName,
          lastName: u.user.lastName,
          email: u.user.email,
          permissions: u.permissions
        }
      })
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
      include: {
        users: { include: { user: true } },
        taggedEvidence: true,
        mediaEvidence: true
      }
    }).then(cases =>
      cases.filter(entry =>
        entry.users.find(u => u.userId === user.id)?.hasPermission(CasePermission.view)
      )
    );

    const data = cases.map(this.caseToCaseData);

    return { data };
  }

  @Get(':id')
  async findOne(@Param('id') id: string, @User() user: UserEntity) {
    await checkCaseVisibility(this.prisma, id, user.id);

    const data = await this.prisma.case.findUnique({
      where: { id },
      include: {
        mediaEvidence: true,
        taggedEvidence: true,
        users: true
      }
    });

    if (!data) {
      throw new NotFoundException();
    }

    return { data };
  }

  @Post()
  async create(@User() user: UserEntity, @Body() caseData: CaseDto) {

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
      include: {
        users: { include: { user: true } },
        taggedEvidence: true,
        mediaEvidence: true
      }
    });

    return { data: this.caseToCaseData(createdCase) };
  }

  @Patch(':id')
  async update(@Param('id') id: string, @User() user: UserEntity, @Body() caseData: CaseUpdateDto) {
    const caseUser = await checkCaseVisibility(this.prisma, id, user.id);

    if (!caseUser.hasPermission(CasePermission.manage)) {
      throw new ForbiddenException("Permission denied");
    }

    const data = await this.prisma.case.update({
      where: { id },
      data: caseData,
    });

    return { data };
  }

}
