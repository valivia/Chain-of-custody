import { Controller, Get, Param, Post } from '@nestjs/common';
import { TaggedEvidence } from '@prisma/client';
import { PrismaService } from 'src/services/prisma.service';

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
  async create(taggedEvidence: TaggedEvidence) {
    const data = await this.prisma.taggedEvidence.create({
      data: taggedEvidence,
    });

    return { data };
  }
}
