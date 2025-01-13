import { BadRequestException, Body, Controller, Get, Param, Post, UploadedFile, UseInterceptors } from '@nestjs/common';
import { FileInterceptor } from "@nestjs/platform-express";
import { Type } from "class-transformer";
import { IsString, IsOptional, IsDate, MinDate, IsLatLong } from "class-validator";
import { writeFile } from "fs/promises";
import { User, UserEntity } from "src/guards/auth.guard";
import { PrismaService } from "src/services/prisma.service";

class MediaEvidenceDto {
  @IsOptional()
  @Type(() => Date)
  @IsDate()
  @MinDate(new Date())
  madeOn: Date;

  @IsString()
  caseId: string;

  @IsLatLong()
  coordinates: string;
}


@Controller('evidence/media')
export class MediaController {
  constructor(private readonly prisma: PrismaService) { }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    const data = await this.prisma.mediaEvidence.findUnique({
      where: { id },
    });

    // TODO: permissions!!

    return { data };
  }

  @Post()
  @UseInterceptors(FileInterceptor('file'))
  async create(@User() user: UserEntity, @UploadedFile() file: Express.Multer.File | undefined, @Body() input: MediaEvidenceDto) {
    if (!file) {
      throw new BadRequestException("File not found");
    }

    const { caseId } = input;

    const caseData = await this.prisma.case.findUnique({
      where: { id: caseId },
    });

    if (!caseData) {
      throw new BadRequestException("Case not found");
    }

    // TODO: permissions!!}

    const evidence = await this.prisma.mediaEvidence.create({
      data: {
        madeOn: input.madeOn,
        originCoordinates: input.coordinates,
        case: { connect: { id: caseId } },
        createdBy: { connect: { id: user.id } },
      }
    });

    // save to disk
    await writeFile(`./data/evidence/${evidence.id}.jpg`, file.buffer);


    return { evidence };
  }
}
