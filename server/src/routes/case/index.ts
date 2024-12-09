import { FastifyInstance } from "fastify";

function routes(fastify: FastifyInstance) {
    fastify.get("/", async (request, reply) => {
        return { cases: await fastify.prisma.case.findMany() };
    });
}

//ESM
export default routes;