import { NotFoundException } from "@nestjs/common";
import { PrismaService } from "src/services/prisma.service";

export enum CasePermission {
  view = 1,
  manage = 2,
  addEvidence = 4,
  removeEvidence = 8,
  deleteCase = 16,
}

export function getAllCasePermissions() {
  return Object.values(CasePermission)
    .filter(value => typeof value === 'number')
    .reduce((acc, p) => acc | p, 0);
}

export async function checkCaseVisibility(db: PrismaService, caseId: string, userId: string) {
  const caseUser = await db.caseUser.findUnique({
    where: {
      caseId_userId: {
        caseId,
        userId,
      },
    },
  });

  if (!caseUser || !caseUser.hasPermission(CasePermission.view)) {
    throw new NotFoundException();
  }

  return caseUser;
}
