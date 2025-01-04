import { Body, Controller, ForbiddenException, Get, NotFoundException, Param, Patch, Post } from '@nestjs/common';
import { Case, CaseStatus, CaseUser } from "@prisma/client";
import { IsEnum, IsString } from "class-validator";
import { User, UserEntity } from "src/guards/auth.guard";
import { PrismaService } from 'src/services/prisma.service';

class CaseDto {
  @IsString()
  title: string;

  @IsString()
  description: string;
}

class CaseUpdateDto extends CaseDto {
  @IsString()
  @IsEnum(CaseStatus)
  status: CaseStatus;
}


@Controller('case')
export class CaseController {
  constructor(private readonly prisma: PrismaService) { }

  async canAccess(caseData: Case & { users: CaseUser[] }, user: UserEntity) {
    const userInCase = caseData.users.find(u => u.userId === user.id);

    if (!userInCase) {
      throw new ForbiddenException();
    }
  }

  @Get(':id')
  async findOne(@Param('id') id: string, @User() user: UserEntity) {
    const data = await this.prisma.case.findUnique({
      where: { id },
      include: {
        mediaEvidence: true,
        taggedEvidence: true,
        users: true
      }
    });

    if (!data) {
      throw new NotFoundException();
    }

    await this.canAccess(data, user);


    return { data };
  }

  @Post()
  async create(@User() user: UserEntity, @Body() caseData: CaseDto) {

    const data = await this.prisma.case.create({
      data: {
        ...caseData,
        users: {
          createMany: {
            data: [
              { userId: user.id }
            ]
          }
        }
      },
    });

    return { data };
  }

  @Patch(':id')
  async update(@Param('id') id: string, @User() user: UserEntity, @Body() caseData: CaseUpdateDto) {

    const foundCase = await this.prisma.case.findUnique({
      where: { id },
      include: {
        users: true
      }
    });

    if (!foundCase) {
      throw new NotFoundException();
    }

    await this.canAccess(foundCase, user);

    const data = await this.prisma.case.update({
      where: { id },
      data: caseData,
    });

    return { data };
  }

}
