import { OnModuleInit } from "@nestjs/common";
import { PrismaClient } from '@prisma/client';

export class PrismaService extends getExtendedClient() implements OnModuleInit {

  async onModuleInit() {
    await this.$connect();
  }
}

function getExtendedClient() {
  const client = () => new PrismaClient().$extends({
    result: {
      caseUser: {
        hasPermission: {
          needs: { permissions: true },
          compute(user) {
            return (bitvise: number): boolean => (parseInt(user.permissions, 2) & bitvise) === bitvise;
          },
        },
      },
    },
  })

  return class {
    constructor() { return client() }
  } as (new () => ReturnType<typeof client>)
}
