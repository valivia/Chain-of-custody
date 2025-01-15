import { Body, Controller, Delete, ForbiddenException, NotFoundException, Param, Post } from '@nestjs/common';
import { IsString } from "class-validator";
import { User, UserEntity } from "src/guards/auth.guard";
import { PrismaService } from 'src/services/prisma.service';
import { CasePermission, checkCaseVisibility } from "../permissions";

class CaseUserDto {
  @IsString()
  userId: string;

  @IsString()
  permissions: string;
}

@Controller('case/:caseId/user')
export class CaseUserController {
  constructor(private readonly prisma: PrismaService) { }

  @Post()
  async addUser(@Param('caseId') caseId: string, @User() user: UserEntity, @Body() input: CaseUserDto) {
    // Check if the user has permission to manage the case
    const caseUser = await checkCaseVisibility(this.prisma, caseId, user.id);
    if (!caseUser.hasPermission(CasePermission.manage)) {
      throw new ForbiddenException("Permission denied");
    }

    // Validate the user to add
    const userToAdd = await this.prisma.user.findUnique({
      where: { id: input.userId },
    });

    if (!userToAdd) {
      throw new NotFoundException("User not found");
    }

    // Add user to the case
    const newCaseUser = await this.prisma.caseUser.create({
      data: {
        case: { connect: { id: caseId } },
        user: { connect: { id: input.userId } },
        permissions: input.permissions,
      },
    });

    return { data: newCaseUser };
  }

  @Delete('/:userId')
  async removeUser(@Param('caseId') caseId: string, @Param('userId') userId: string, @User() user: UserEntity) {
    // Check if the user has permission to manage the case
    const caseUser = await checkCaseVisibility(this.prisma, caseId, user.id);
    if (!caseUser.hasPermission(CasePermission.manage)) {
      throw new ForbiddenException("Permission denied");
    }

    // Validate the user to remove
    const userToRemove = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!userToRemove) {
      throw new NotFoundException("User not found");
    }

    // Remove user from the case
    const deletedCaseUser = await this.prisma.caseUser.delete({
      where: {
        caseId_userId: {
          caseId,
          userId,
        },
      },
    });

    return { data: deletedCaseUser };
  }

}
