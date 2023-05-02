"use strict";
import fp from "fastify-plugin";
import fastifyPostgres from "@fastify/postgres";

export default fp(async (fastify) => {
  
  fastify.register(fastifyPostgres, {
    connectionString: fastify.config.API_POSTGRES_URI /* other postgres options */,
  })

})
