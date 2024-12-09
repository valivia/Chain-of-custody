import { FastifyInstance } from "fastify";
import caseRoutes from "./case/index";
import evidenceRoutes from "./evidence/index";

export function routes(fastify: FastifyInstance) {
    fastify.register(caseRoutes, { prefix: "/case" });
    fastify.register(evidenceRoutes, { prefix: "/evidence" });
}
