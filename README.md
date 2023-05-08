# OpenSociocracy

OpenSociocracy is an effort to create a permissively licensed set of S3 tools.

## Tech Stack

* Quasar / Vue3 / Typescript front end
* Fastify API, in TypeScript
* Postgres
* Redis
* SuperTokens
* Local Docker stack
* TypeScript CDK to deploy to AWS

## Build in Public

The open build start May 7, 2023. If you are reading this you found the code.

You can follow the [build in public on Twitter](https://twitter.com/OpenSociocracy) or on our [Discord](https://discord.gg/seExDy6M) channel.

## Ride along

Install Node 18 

```
nvm install 18
nvm use 18
```

Install CDK CLI

```
npm install -g aws-cdk
```

Create code dir, you must init CDK in an empty directory

```
mkdir aws
cd aws
```

Install CDK modules

```
npm install aws-cdk-lib
```

Create TypeScript CDK project

```
cdk init app --language typescript
```

done...

```
The `cdk.json` file tells the CDK Toolkit how to execute your app.

## Useful commands

* `npm run build`   compile typescript to js
* `npm run watch`   watch for changes and compile
* `npm run test`    perform the jest unit tests
* `cdk deploy`      deploy this stack to your default AWS account/region
* `cdk diff`        compare deployed stack with current state
* `cdk synth`       emits the synthesized CloudFormation template

Executing npm install...
✅ All done!
```


