import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from "@nestjs/jwt";
import { PrismaService } from "src/services/prisma.service";
import * as bcrypt from "bcrypt";
import { User } from "@prisma/client";

@Injectable()
export class AuthService {
  constructor(private prisma: PrismaService, private jwtService: JwtService) { }

  async signIn(email: string, pass: string): Promise<any> {
    const user = await this.prisma.user.findUnique({ where: { email } });

    if (!user || !(await bcrypt.compare(pass, user.password))) {
      throw new UnauthorizedException("Email or password is incorrect");
    }

    const payload = { sub: user.id, firstName: user.firstName, lastName: user.lastName, email: user.email };

    return {
      access_token: await this.jwtService.signAsync(payload),
    };
  }

  async createUser(user: User): Promise<any> {
    const hashedPassword = await bcrypt.hash(user.password, 10);
    const newUser = await this.prisma.user.create({
      data: {
        ...user,
        password: hashedPassword,
        firstName: "John",
        lastName: "Doe",
      }
    });

    return this.signIn(newUser.email, user.password);
  }
}
