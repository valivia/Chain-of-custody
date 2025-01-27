import { Module } from '@nestjs/common';
import { PrismaService } from "./services/prisma.service";
import { EvidenceController } from './routes/media/evidence/evidence.controller';
import { MediaController } from "./routes/evidence/media/media.controller";
import { AuthProvider } from "./guards/auth.guard";
import { AuthModule } from "./routes/auth/auth.module";
import { CaseController } from "./routes/case/case.controller";
import { TagController } from "./routes/evidence/tag/tag.controller";
import { ConfigModule } from "@nestjs/config";
import { validationSchema } from "./util/config";
import { DevmodeProvider } from "./guards/dev.guard";
import { CaseUserController } from "./routes/case/user/case_user.controller";
import { UtilController } from "./routes/util/util.controller";

@Module({
  imports: [
    AuthModule,
    ConfigModule.forRoot({
      isGlobal: true,
      validationSchema,
      validationOptions: {
        abortEarly: true,
      },
    }),
  ],
  controllers: [CaseController, UtilController, CaseUserController, MediaController, TagController, EvidenceController],
  providers: [
    PrismaService,
    AuthProvider,
    DevmodeProvider,
  ],
})
export class AppModule { }
