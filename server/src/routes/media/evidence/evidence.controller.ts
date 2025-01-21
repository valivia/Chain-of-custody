import { Controller, Get, NotFoundException, Param, Res, StreamableFile } from '@nestjs/common';
import { Response } from "express";
import { createReadStream, existsSync } from "fs";
import { join } from "path";
import { User, UserEntity } from "src/guards/auth.guard";
import { checkCaseVisibility } from "src/routes/case/permissions";
import { PrismaService } from "src/services/prisma.service";

@Controller('media/evidence')
export class EvidenceController {
  constructor(private readonly prisma: PrismaService) { }

  @Get(':id')
  async findOne(@User() user: UserEntity, @Param('id') id: string, @Res({ passthrough: true }) res: Response): Promise<StreamableFile> {
    const mediaEvidence = await this.prisma.mediaEvidence.findUnique({
      where: { id },
      include: { case: true }
    });

    if (!mediaEvidence) {
      throw new NotFoundException();
    }

    await checkCaseVisibility(this.prisma, mediaEvidence.caseId, user.id);

    const fileName = `${mediaEvidence.id}.jpg`;
    const path = join(process.cwd(), `data/evidence/${fileName}`);

    if (!existsSync(path)) {
      throw new NotFoundException();
    }

    // Open file
    const stream = createReadStream(path);

    res.set({ 'Content-Disposition': `attachment; filename=${fileName}`, 'Content-Type': 'image/jpeg' });
    return new StreamableFile(stream);
  }
}
