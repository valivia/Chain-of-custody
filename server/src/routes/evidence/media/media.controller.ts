import { Controller, Get, Param } from '@nestjs/common';
import { PrismaService } from "src/services/prisma.service";

@Controller('evidence/media')
export class MediaController {
  constructor(private readonly prisma: PrismaService) { }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    const data = await this.prisma.mediaEvidence.findUnique({
      where: { id },
    });

    return { data };
  }
}
