import { BadRequestException, Body, Controller, Get, Param, Post, Req } from '@nestjs/common';
import { Action } from "@prisma/client";
import { IsLatLong, IsNumber, IsOptional, IsString } from "class-validator";
import { Request } from "express";
import { Public, User, UserEntity } from "src/guards/auth.guard";
import { getIp } from "src/lib/request";
import { PrismaService } from 'src/services/prisma.service';


class TaggedEvidenceDto {
  @IsString()
  id: string;

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


  // TODO: remove, demo
  @Public()
  @Get()
  async getAll() {
    const data = await this.prisma.taggedEvidence.findMany();

    return { data };
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    const data = await this.prisma.taggedEvidence.findUnique({
      where: { id },
    });

    return { data };
  }

  @Post()
  async create(@User() user: UserEntity, @Body() taggedEvidence: TaggedEvidenceDto) {

    const data = await this.prisma.taggedEvidence.create({
      data: {
        ...taggedEvidence,
        id: undefined, // TODO: remove, demo
        userId: user.id,
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
