import { Body, Controller, ForbiddenException, Get, NotFoundException, Param, Post, Req } from '@nestjs/common';
import { Action } from "@prisma/client";
import { Type } from "class-transformer";
import { IsDate, IsLatLong, IsNumber, IsOptional, IsString, MinDate } from "class-validator";
import { Request } from "express";
import { User, UserEntity } from "src/guards/auth.guard";
import { getIp } from "src/lib/request";
import { checkCaseVisibility, CasePermission } from "src/routes/case/permissions";
import { PrismaService } from 'src/services/prisma.service';


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

  @IsNumber()
  containerType: number;

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
      throw new NotFoundException("Evidence not found");
    }

    await checkCaseVisibility(this.prisma, taggedEvidence.caseId, user.id);

    return { data: taggedEvidence };
  }

  @Post()
  async create(@User() user: UserEntity, @Body() input: TaggedEvidenceDto) {

    const { caseId, ...taggedEvidence } = input;

    const caseUser = await checkCaseVisibility(this.prisma, caseId, user.id);
    if (!caseUser.hasPermission(CasePermission.addEvidence)) {
      throw new ForbiddenException("Permission denied");
    }

    const data = await this.prisma.taggedEvidence.create({
      data: {
        ...taggedEvidence,
        id: undefined,
        createdBy: { connect: { id: user.id } },
        case: { connect: { id: caseId }, },
      },
    });

    return { data };
  }


  @Post(':id/transfer')
  async transfer(@Req() req: Request, @User() user: UserEntity, @Param('id') id: string, @Body() body: TransferDto) {
    const userAgent = req.header("user-agent") ?? "unknown";
    const ip = getIp(req);

    const evidence = await this.prisma.taggedEvidence.findUnique({
      where: { id },
    });

    if (!evidence) {
      throw new NotFoundException("Evidence not found");
    }

    await this.prisma.auditLog.create({
      data: {
        ip,
        userAgent,
        location: body.coordinates,
        userId: user.id,
        action: Action.TRANSFER,
        taggedEvidenceId: id,
      },
    });

    return;
  }
}
