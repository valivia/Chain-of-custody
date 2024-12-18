import { Body, Controller, Post, HttpCode, HttpStatus } from '@nestjs/common';
import { AuthService } from './auth.service';
import { Public } from "../../guards/auth.guard";
import { User } from "@prisma/client";
import { IsEmail, IsString } from "class-validator";
import { DevOnly } from "src/guards/dev.guard";
import { Transform } from "class-transformer";

class SignInDTO {

  @IsEmail()
  @Transform(({ value }) => value.trim())
  email: string;

  @IsString()
  @Transform(({ value }) => value.trim())
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
  signIn(@Body() body: SignInDTO) {
    return this.authService.signIn(body.email, body.password);
  }

  @Public()
  @DevOnly()
  @HttpCode(HttpStatus.CREATED)
  @Post('register')
  createUser(@Body() body: RegisterDTO) {
    return this.authService.createUser(body as User);
  }

}

