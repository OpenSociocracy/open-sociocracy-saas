import fastifyPlugin from "fastify-plugin";
import accountServicePlugin from "../services/accountService.js";

import Passwordless from "supertokens-node/recipe/passwordless/index.js";
import { verifySession } from "supertokens-node/recipe/session/framework/fastify/index.js";
import st from "supertokens-node/framework/fastify/index.js";
const { SessionRequest } = st;

async function accountRoutes(server, options) {
  server.register(accountServicePlugin);

  server.get(
    "/accounts",
    {
      preHandler: verifySession(),
      schema: {
        description: "Return authenticated member's accounts",
        tags: ["account"],
        response: {
          200: {
            description: "Success Response",
            type: "object",
            properties: {
              accounts: { type: "array" },
            },
          },
        },
      },
    },
    async (request, reply) => {
      
      let memberUid = request.session.getUserId();

      const accounts = await server.accountService.getMemberAccounts(memberUid);

      return {
        accounts: accounts,
      };
    }
  );

  server.get(
    "/accounts/:accountUid/nuggets",
    {
      preHandler: verifySession(),
      schema: {
        description: "Return account nuggets",
        tags: ["account"],
        querystring: {
          t: { type: 'string' }
        },
        response: {
          200: {
            description: "Success Response",
            type: "object",
            properties: {
              nuggets: { type: "array" },
            },
          },
        },
      },
    },
    async (request, reply) => {
      
      let memberUid = request.session.getUserId();
      let accountUid = request.params.accountUid;
      let nuggetType = request.query.t

      const nuggets = await server.accountService.getAccountNuggets(memberUid, accountUid, nuggetType);

      return {
        nuggets: nuggets,
      };
    }
  );

    server.post(
    "/accounts",
    {
      preHandler: verifySession(),
      schema: {
        description: "Create a new account",
        tags: ["account"],
        summary: "Add a new account to the database",
        body: {
          type: "object",
          properties: {
            name: {
              type: "string",
              description: "The name for the account",
            },
          },
        },
        response: {
          200: {
            description: "Success Response",
            type: "object",
            properties: {
              uid: { type: "string" },
              name: { type: "string" },
              createdAt: { type: "string" }
            },
          },
        },
      },
    },
    async (req, reply) => {
      let userId = req.session.getUserId();
      console.log("USERID", userId);

      const result = await server.accountService.createAccount(req.body, userId);
      console.log("CREATE", result);

      return result;
    }
  );

  server.get(
    "/accounts/member",
    {
      preHandler: verifySession(),
      schema: {
        description: "Returns accounts the member can access",
        tags: ["member"],
        response: {
          200: {
            description: "Success Response",
            type: "object",
            properties: {
              accounts: { type: "array" },
            },
          },
        },
      },
    },
    async (request, reply) => {
      let userId = request.session.getUserId();

      console.log("MEMBER ACCOUNTS");

      const accounts = await server.accountService.getMemberAccounts(userId);

      return {
        accounts: accounts,
      };
    }
  );
}

export default fastifyPlugin(accountRoutes);
