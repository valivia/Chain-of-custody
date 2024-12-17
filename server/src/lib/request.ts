import { Request } from "express";

export function getIp(request: Request): string {
  return request.header("cf-connecting-ip") ?? request.header("x-real-ip") ?? request.header("x-forwarded-for") ?? request.ip ?? "unknown";
}
