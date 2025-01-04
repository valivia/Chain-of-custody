import { BadRequestException, Body, Controller, Get, Param, Post, Req } from '@nestjs/common';
import { Action } from "@prisma/client";
import { IsLatLong, IsNumber, IsOptional, IsString } from "class-validator";
import { Request } from "express";
import { User, UserEntity } from "src/guards/auth.guard";
import { getIp } from "src/lib/request";
import { PrismaService } from 'src/services/prisma.service';


class TaggedEvidenceDto {
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
  async findOne(@Param('id') id: string) {
    const data = await this.prisma.taggedEvidence.findUnique({
      where: { id },
    });

    return { data };
  }

  @Post()
  async create(@User() user: UserEntity, @Body() input: TaggedEvidenceDto) {

    const { caseId, ...taggedEvidence } = input;

    const caseData = await this.prisma.case.findUnique({
      where: { id: caseId },
    });

    if (!caseData) {
      throw new BadRequestException("Case not found");
    }

    // TODO check if user has access to the case

    const data = await this.prisma.taggedEvidence.create({
      data: {
        ...taggedEvidence,
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
      throw new BadRequestException("Evidence not found");
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
