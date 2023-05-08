import { Construct } from "constructs";
import {
  aws_ec2 as ec2,
  aws_route53 as route53,
  aws_elasticache as elasticache,
  aws_rds as rds
} from 'aws-cdk-lib';
import {readFileSync} from 'fs';
import * as cdk from "aws-cdk-lib";
import { Aspects, CfnOutput, Duration } from 'aws-cdk-lib';
import { CfnDBCluster } from 'aws-cdk-lib/aws-rds';

const stackName = "OpenSociocracyStack";

export class OpensociocracyStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // The code that defines your stack goes here

    // example resource
    // const queue = new sqs.Queue(this, 'OpensociocracyQueue', {
    //   visibilityTimeout: cdk.Duration.seconds(300)
    // });
  }
}
