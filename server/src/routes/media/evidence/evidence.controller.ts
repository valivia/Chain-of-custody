import { Controller, Get, NotFoundException, Param, Res, StreamableFile } from '@nestjs/common';
import { Response } from "express";
import { createReadStream } from "fs";
import { join } from "path";
import { User, UserEntity } from "src/guards/auth.guard";
import { checkCaseVisibility } from "src/routes/case/permissions";
import { PrismaService } from "src/services/prisma.service";

@Controller('media/evidence')
export class EvidenceController {
  constructor(private readonly prisma: PrismaService) { }

  @Get(':id')
  async findOne(@User() user: UserEntity, @Param('id') id: string, @Res({ passthrough: true }) res: Response): Promise<StreamableFile> {
    // Get evidence info
    const mediaEvidence = await this.prisma.mediaEvidence.findUnique({
      where: { id },
      include: { case: true }
    });

    if (!mediaEvidence) {
      throw new NotFoundException();
    }

    await checkCaseVisibility(this.prisma, mediaEvidence.caseId, user.id);

    const fileName = `${mediaEvidence.id}.jpg`;
    res.set({ 'Content-Disposition': `attachment; filename=${fileName}`, 'Content-Type': 'image/jpeg' });

    // Open file
    const stream = createReadStream(join(process.cwd(), `data/evidence/${fileName}`));
    return new StreamableFile(stream);
  }
}
