import { Action } from "@prisma/client";
import { Request } from "express";
import { getIp } from "src/lib/request";
import { PrismaService } from "src/services/prisma.service";

interface AuditLogData {
  action: Action;
  oldData?: Record<string, unknown>;
  newData?: Record<string, unknown>;
  location?: string;
  userId?: string;
  caseId?: string;
  caseUserId?: string;
  mediaEvidenceId?: string;
  taggedEvidenceId?: string;
}

export async function saveToAuditLog(db: PrismaService, req: Request, data: AuditLogData) {
  const { action, oldData, newData, userId, caseId, caseUserId, mediaEvidenceId, taggedEvidenceId, location } = data;

  return db.auditLog.create({
    data: {
      // Data
      action,
      oldData: oldData ? JSON.stringify(oldData) : undefined,
      newData: newData ? JSON.stringify(newData) : undefined,
      location,
      // Device
      ip: getIp(req),
      userAgent: req.header("user-agent") ?? "unknown",
      // Relations
      user: userId ? { connect: { id: userId } } : {},
      case: caseId ? { connect: { id: caseId } } : {},
      caseUser: caseUserId ? { connect: { id: caseUserId } } : {},
      mediaEvidence: mediaEvidenceId ? { connect: { id: mediaEvidenceId } } : {},
      taggedEvidence: taggedEvidenceId ? { connect: { id: taggedEvidenceId } } : {},
    }
  });

}
