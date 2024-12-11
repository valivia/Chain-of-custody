import { Module } from '@nestjs/common';
import { CaseController } from './case/case.controller';
import { MediaController } from './evidence/media/media.controller';
import { TagController } from './evidence/tag/tag.controller';
import { PrismaService } from "./services/prisma.service";
import { EvidenceController } from './media/evidence/evidence.controller';

@Module({
  imports: [],
  controllers: [CaseController, MediaController, TagController, EvidenceController],
  providers: [PrismaService],
})
export class AppModule { }
