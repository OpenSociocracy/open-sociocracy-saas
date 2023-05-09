import fp from 'fastify-plugin'
import swagger from '@fastify/swagger'
import swaggerUi from '@fastify/swagger-ui'

export default fp(async (fastify) => {
  fastify.register(swagger, {
    openapi: {
      info: {
        title: 'OpenSociocray',
        description: 'Using Sociocracy to build Sociocracy tools',
        version: '0.1.0'
      },
      servers: [
        {
          url: 'https://api.opensociocracy.org/',
        }
      ]
    },
    hideUntagged: true
  })
  fastify.register(swaggerUi)
})
