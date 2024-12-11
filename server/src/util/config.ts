import * as Joi from "joi";

export default () => {

  const jwt_secret = process.env.JWT_SECRET;
  if (!jwt_secret) {
    throw new Error('JWT_SECRET must be provided');
  }

  const config = {
    port: parseInt(process.env.PORT || "3000", 10),
    jwt_secret,
  }

  return config;
};

export const validationSchema = Joi.object({
  DATABASE_URL: Joi.string().required(),
  PORT: Joi.number().default(3000),
  JWT_SECRET: Joi.string().required(),
});
