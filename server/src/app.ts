import Fastify from "fastify";
import prismaPlugin from "./plugins/prisma";
import { routes } from "./routes";

const app = Fastify({
  logger: true
});

const start = async () => {
  app.register(prismaPlugin);
  app.register(routes);

  await app.listen({ port: 3000 });
};

start()
  .catch((error) => {
    app.log.error(error);
    process.exit(1);
  });