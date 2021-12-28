import { LambdaApiDeployment } from './types/LambdaApiPackage';
import { getAWSUser } from '@goldstack/infra-aws';
import { deployFunction, LambdaConfig } from '@goldstack/utils-aws-lambda';

import { readLambdaConfig } from '@goldstack/utils-aws-lambda';
import { defaultRoutesPath } from './templateLambdaConsts';

import { mkdir, rmSafe } from '@goldstack/utils-sh';
import { generateFunctionName } from './generateLambdaConfig';
import { getOutDirForLambda } from './templateLambdaApiBuild';

interface DeployLambdaParams {
  deployment: LambdaApiDeployment;
  config: LambdaConfig[];
}

export const deployLambda = async (
  params: DeployLambdaParams
): Promise<void> => {
  const lambdaConfig = readLambdaConfig(defaultRoutesPath);

  for await (const config of lambdaConfig) {
    const functionName = generateFunctionName(params.deployment, config);
    const functionDir = getOutDirForLambda(config);
    mkdir('-p', functionDir);
    const targetArchive = `${functionDir}/${config.name}.zip`;
    await rmSafe(targetArchive);
    await deployFunction({
      targetArchiveName: targetArchive,
      lambdaPackageDir: functionDir,
      awsCredentials: await getAWSUser(params.deployment.awsUser),
      region: params.deployment.awsRegion,
      functionName,
    });
  }
};

export const deployCli = async (
  deployment: LambdaApiDeployment,
  config: LambdaConfig[]
): Promise<void> => {
  await deployLambda({
    deployment,
    config,
  });
};
