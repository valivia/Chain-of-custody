import { BadRequestException, Body, Controller, ForbiddenException, Get, NotFoundException, Param, Post, Req } from '@nestjs/common';
import { Action } from "@prisma/client";
import { Type } from "class-transformer";
import { IsDate, IsLatLong, IsOptional, IsString, MinDate } from "class-validator";
import { Request } from "express";
import { User, UserEntity } from "src/guards/auth.guard";
import { checkCaseVisibility, CasePermission } from "src/routes/case/permissions";
import { PrismaService } from 'src/services/prisma.service';
import { saveToAuditLog } from "src/util/auditlog";


class TaggedEvidenceDto {
  @IsString()
  id: string;

  @IsOptional()
  @Type(() => Date)
  @IsDate()
  @MinDate(new Date())
  madeOn: Date;

  @IsString()
  caseId: string;

  @IsString()
  containerType: string;

  @IsString()
  itemType: string;

  @IsOptional()
  @IsString()
  description: string;

  @IsLatLong()
  originCoordinates: string;

  @IsString()
  originLocationDescription: string;
}

class TransferDto {
  @IsLatLong()
  coordinates: string;
}

@Controller('evidence/tag')
export class TagController {
  constructor(private readonly prisma: PrismaService) { }

  @Get(':id')
  async findOne(@Param('id') id: string, @User() user: UserEntity) {
    const taggedEvidence = await this.prisma.taggedEvidence.findUnique({
      where: { id },
    });

    if (!taggedEvidence) {
      throw new NotFoundException();
    }

    await checkCaseVisibility(this.prisma, taggedEvidence.caseId, user.id);

    return { data: taggedEvidence };
  }

  @Post()
  async create(@User() user: UserEntity, @Req() req: Request, @Body() input: TaggedEvidenceDto) {

    const { caseId, ...taggedEvidence } = input;

    // Permission check
    const caseUser = await checkCaseVisibility(this.prisma, caseId, user.id);
    if (!caseUser.hasPermission(CasePermission.addEvidence)) {
      throw new ForbiddenException("Permission denied");
    }

    // Duplicate check
    const existingEvidence = await this.prisma.taggedEvidence.findUnique({
      where: { id: input.id },
    });

    if (existingEvidence) {
      throw new BadRequestException("Evidence already exists");
    }

    // Create the evidence
    const createdEvidence = await this.prisma.taggedEvidence.create({
      data: {
        ...taggedEvidence,
        id: undefined,
        createdBy: { connect: { id: user.id } },
        case: { connect: { id: caseId }, },
      },
    });

    await saveToAuditLog(this.prisma, req, {
      action: Action.create,
      newData: createdEvidence,
      userId: user.id,
      taggedEvidenceId: createdEvidence.id,
    });

    return { data: createdEvidence };
  }


  @Post(':id/transfer')
  async transfer(@Req() req: Request, @User() user: UserEntity, @Param('id') id: string, @Body() body: TransferDto) {

    const evidence = await this.prisma.taggedEvidence.findUnique({
      where: { id },
    });

    if (!evidence) {
      throw new NotFoundException();
    }

    await saveToAuditLog(this.prisma, req, {
      action: Action.transfer,
      userId: user.id,
      taggedEvidenceId: id,
      location: body.coordinates,
    });

    return;
  }
}
