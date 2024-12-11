import { CanActivate, ExecutionContext, Injectable, SetMetadata } from "@nestjs/common";
import { APP_GUARD, Reflector } from "@nestjs/core";

export const IS_DEV_KEY = 'isDev';
export const DevOnly = () => SetMetadata(IS_DEV_KEY, true);

@Injectable()
export class DevelopmentGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) { }

  canActivate(context: ExecutionContext): boolean {
    const devOnly = this.reflector.getAllAndOverride<boolean>(
      IS_DEV_KEY,
      [context.getHandler(), context.getClass()]
    );

    if (devOnly) {
      return process.env.NODE_ENV === 'development';
    }

    return true;
  }
}

export const DevmodeProvider = {
  provide: APP_GUARD,
  useClass: DevelopmentGuard,
};

