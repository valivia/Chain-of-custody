import { BadRequestException, Body, Controller, ForbiddenException, Get, NotFoundException, Param, Post, Req, UploadedFile, UseInterceptors } from '@nestjs/common';
import { FileInterceptor } from "@nestjs/platform-express";
import { Action } from "@prisma/client";
import { Type } from "class-transformer";
import { IsString, IsOptional, IsDate, MinDate, IsLatLong } from "class-validator";
import { Request } from "express";
import { writeFile } from "fs/promises";
import { User, UserEntity } from "src/guards/auth.guard";
import { CasePermission, checkCaseVisibility } from "src/routes/case/permissions";
import { PrismaService } from "src/services/prisma.service";
import { saveToAuditLog } from "src/util/auditlog";

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
  async findOne(@Param('id') id: string, @User() user: UserEntity) {
    const mediaEvidence = await this.prisma.mediaEvidence.findUnique({
      where: { id },
    });

    if (!mediaEvidence) {
      throw new NotFoundException();
    }

    await checkCaseVisibility(this.prisma, mediaEvidence.caseId, user.id);

    return { data: mediaEvidence };
  }

  @Post()
  @UseInterceptors(FileInterceptor('file'))
  async create(@Req() req: Request, @User() user: UserEntity, @UploadedFile() file: Express.Multer.File | undefined, @Body() input: MediaEvidenceDto) {
    if (!file) {
      throw new BadRequestException("File not found");
    }

    const caseUser = await checkCaseVisibility(this.prisma, input.caseId, user.id);

    if (!caseUser.hasPermission(CasePermission.addEvidence)) {
      throw new ForbiddenException("Permission denied");
    }

    const evidence = await this.prisma.mediaEvidence.create({
      data: {
        madeOn: input.madeOn,
        originCoordinates: input.coordinates,
        case: { connect: { id: input.caseId } },
        createdBy: { connect: { id: user.id } },
      }
    });

    await saveToAuditLog(this.prisma, req, {
      action: Action.create,
      newData: evidence,
      userId: user.id,
      caseId: input.caseId,
      mediaEvidenceId: evidence.id,
    });

    // save to disk
    await writeFile(`./data/evidence/${evidence.id}.jpg`, file.buffer);


    return { data: evidence };
  }
}
