import fp from 'fastify-plugin'
import swagger from '@fastify/swagger'
import swaggerUi from '@fastify/swagger-ui'

export default fp(async (fastify) => {
  fastify.register(swagger, {
    openapi: {
      info: {
        title: 'OpenSociocracy',
        description: 'Using Sociocracy to build Sociocracy tools',
        version: '0.1.0'
      },
      servers: [
        {
          url: 'https://api.opensociocracy.org/',
        }
      ]
    },
    hideUntagged: true,
    
  })
  fastify.register(swaggerUi, {logo: {
    type: 'image/png',
    content: Buffer.from('https://handbook.opensociocracy.org/logo_light.jpg', 'base64')
  },
  theme: {
    favicon: [
      {
        filename: 'favicon.png',
        rel: 'icon',
        sizes: '16x16',
        type: 'image/png',
        content: Buffer.from('https://handbook.opensociocracy.org/logo_light.jpg', 'base64')
      }
    ]
  }})
})
