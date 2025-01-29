import { BadRequestException, Body, Controller, Delete, ForbiddenException, NotFoundException, Param, Post, Req } from '@nestjs/common';
import { IsString } from "class-validator";
import { User, UserEntity } from "src/guards/auth.guard";
import { PrismaService } from 'src/services/prisma.service';
import { CasePermission, checkCaseVisibility } from "../permissions";
import { saveToAuditLog } from "src/util/auditlog";
import { Request } from "express";
import { Action, CaseUser, User as PrismaUser } from "@prisma/client";
import { isValidPermissionString } from "src/util/permissions";

class CaseUserDto {
  @IsString()
  userId: string;

  @IsString()
  permissions: string;
}

export function userToCaseUser(user: (CaseUser & { user: PrismaUser })) {
  return {
    userId: user.userId,
    firstName: user.user.firstName,
    lastName: user.user.lastName,
    email: user.user.email,
    permissions: user.permissions
  }
}


@Controller('case/:caseId/user')
export class CaseUserController {
  constructor(private readonly prisma: PrismaService) { }

  @Post()
  async addUser(@Req() req: Request, @Param('caseId') caseId: string, @User() user: UserEntity, @Body() input: CaseUserDto) {

    if (!isValidPermissionString(CasePermission, input.permissions)) {
      throw new BadRequestException("Invalid permission object");
    }

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

    // Check if the user is already added to the case
    const existingCaseUser = await this.prisma.caseUser.findUnique({
      where: {
        caseId_userId: {
          caseId,
          userId: input.userId,
        },
      },
    });

    if (existingCaseUser) {
      throw new BadRequestException("User already added to the case");
    }

    // Add user to the case
    const newCaseUser = await this.prisma.caseUser.create({
      include: { user: true },
      data: {
        case: { connect: { id: caseId } },
        user: { connect: { id: input.userId } },
        permissions: input.permissions,
      },
    });

    await saveToAuditLog(this.prisma, req, {
      action: Action.create,
      caseId,
      newData: newCaseUser,
      userId: user.id,
      caseUserId: newCaseUser.id,
    });

    return { data: userToCaseUser(newCaseUser) };
  }

  @Delete('/:userId')
  async removeUser(@Req() req: Request, @Param('caseId') caseId: string, @Param('userId') userId: string, @User() user: UserEntity) {
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
      include: { user: true },
      where: {
        caseId_userId: {
          caseId,
          userId,
        },
      },
    });

    await saveToAuditLog(this.prisma, req, {
      action: Action.delete,
      caseId,
      oldData: deletedCaseUser,
      userId: user.id,
      caseUserId: deletedCaseUser.id,
    });

    return { data: userToCaseUser(deletedCaseUser) };
  }

}
