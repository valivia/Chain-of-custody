import { FastifyInstance } from "fastify";

function routes(fastify: FastifyInstance) {
    fastify.get("/", async (request, reply) => {
        return { evidence: await fastify.prisma.taggedEvidence.findMany() };
    });
}

//ESM
export default routes;