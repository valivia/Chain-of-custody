import { Body, Controller, Post, HttpCode, HttpStatus } from '@nestjs/common';
import { AuthService } from './auth.service';
import { Public } from "../../guards/auth.guard";
import { User } from "@prisma/client";
import { IsEmail, IsString } from "class-validator";
import { DevOnly } from "src/guards/dev.guard";

class SignInDTO {
  @IsEmail()
  email: string;
  @IsString()
  password: string;
}

class RegisterDTO extends SignInDTO {
  @IsString()
  firstName: string;
  @IsString()
  lastName: string;
}

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) { }

  @Public()
  @HttpCode(HttpStatus.OK)
  @Post('login')
  signIn(@Body() signInDto: Record<string, any>) {
    return this.authService.signIn(signInDto.email, signInDto.password);
  }

  @Public()
  @DevOnly()
  @HttpCode(HttpStatus.CREATED)
  @Post('register')
  createUser(@Body() user: RegisterDTO) {
    return this.authService.createUser(user as User);
  }

}

