import { Controller, Get, NotFoundException, Param, Res, StreamableFile } from '@nestjs/common';
import { Response } from "express";
import { createReadStream } from "fs";
import { join } from "path";
import { PrismaService } from "src/services/prisma.service";

@Controller('media/evidence')
export class EvidenceController {
  constructor(private readonly prisma: PrismaService) { }

  @Get(':id')
  async findOne(@Param('id') id: string, @Res({ passthrough: true }) res: Response): Promise<StreamableFile> {
    // Get evidence info
    const data = await this.prisma.mediaEvidence.findUnique({
      where: { id },
      include: { cases: { include: { case: { include: { users: true } } } } },
    });

    if (!data) {
      throw new NotFoundException();
    }

    const fileName = `${data.id}.jpg`;
    res.set({ 'Content-Disposition': `attachment; filename=${fileName}` });

    // Open file
    const stream = createReadStream(join(process.cwd(), `data/evidence/${fileName}`));
    return new StreamableFile(stream);
  }
}
