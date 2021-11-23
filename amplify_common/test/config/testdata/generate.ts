import helpers from 'https://dev.jspm.io/amplify-frontend-flutter/lib/amplify-config-helper.js';

const generateConfig = Object.getOwnPropertyDescriptor(helpers, 'generateConfig')?.value;

const region = 'us-west-2';
const defaultMetadata = {
    providers: {
        awscloudformation: {
            Region: region,
        }
    }
}

const authConfigJSON = Deno.readTextFileSync('./awsconfiguration.json');
const authConfig = JSON.parse(authConfigJSON);

interface TestVector {
    name: string;
    metadata: Record<string, any>;
    awsConfig?: Record<string, any>;
}

const makeAppSyncConfig = (authType: string): Record<string, any> => {
    return {
        service: 'AppSync',
        output: {
            authConfig: {
                defaultAuthentication: {
                    authenticationType: authType
                }
            },
            GraphQLAPIEndpointOutput: 'example.com',
            GraphQLAPIKeyOutput: authType === 'API_KEY' ? '12345' : null,
        }
    };
}

const makeRestConfig = (authType?: string): Record<string, any> => {
    return {
        service: 'API Gateway',
        output: {
            RootUrl: 'example.com',
        },
        authorizationType: authType,
    }
}

const testVectors: TestVector[] = [
    {
        name: 'Empty',
        metadata: {
            ...defaultMetadata
        }
    },
    {
        name: 'Analytics',
        metadata: {
            ...defaultMetadata,
            analytics: {
                test: {
                    output: {
                        Id: '12345',
                        Region: region
                    }
                }
            },
        }
    },
    {
        name: 'Auth',
        metadata: {
            ...defaultMetadata,
            auth: {}
        },
        awsConfig: authConfig
    },
    {
        name: 'API',
        metadata: {
            ...defaultMetadata,
            api: {
                API_KEY: {
                    ...makeAppSyncConfig('API_KEY')
                },
                AWS_IAM: {
                    ...makeAppSyncConfig('AWS_IAM')
                },
                REST: {
                    ...makeRestConfig('AMAZON_COGNITO_USER_POOLS')
                },
            }
        }
    }
]

let out = 
        `// GENERATED FILE. DO NOT MODIFY BY HAND.

        class TestData {
            const TestData(this.name, this.config);

            final String name;
            final String config;
        }
        `;

for (const vector of testVectors) {
    const context = {
        amplify: {
            getProjectMeta: () => {
                return vector.metadata
            }
        }
    }
    const config = generateConfig(context, {}, vector.awsConfig)
    const configJSON = JSON.stringify(config, null, '  ')
    out += `const _${vector.name.toLowerCase()} = r'''\n${configJSON}\n''';\n\n`
}

out += 'const allTests = ['
for (const vector of testVectors) {
    out += `TestData('${vector.name}', _${vector.name.toLowerCase()}),\n`
}
out += '];'

const outFile = 'testdata.dart'
await Deno.writeTextFile(outFile, out)
await Deno.run({
    cmd: ['dart', 'format', outFile]
}).status()