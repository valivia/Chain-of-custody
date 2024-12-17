import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { IsNumber, IsOptional, IsString } from "class-validator";
import { Public, User, UserEntity } from "src/guards/auth.guard";
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

  @IsString()
  originCoordinates: string;

  @IsString()
  originLocationDescription: string;
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
}
