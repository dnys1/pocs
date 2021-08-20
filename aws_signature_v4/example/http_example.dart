import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:aws_signature_v4/src/credentials/aws_credential_scope.dart';
import 'package:aws_signature_v4/src/credentials/aws_credentials.dart';
import 'package:aws_signature_v4/src/request/aws_sig_v4_signed_request.dart';
import 'package:aws_signature_v4/src/signer/signer.dart';
import 'package:equatable/equatable.dart';

void main(List<String> args) async {
  EquatableConfig.stringify = true;
  final argParser = ArgParser();

  const accessKeyIdArg = 'access-key-id';
  const accessKeyIdEnv = 'AWS_ACCESS_KEY_ID';

  const secretAccessKeyArg = 'secret-access-key';
  const secretAccessKeyEnv = 'AWS_SECRET_ACCESS_KEY';

  const sessionTokenArg = 'session-token';
  const sessionTokenEnv = 'AWS_SESSION_TOKEN';

  const userPoolIdArg = 'user-pool-id';
  const regionArg = 'region';

  argParser.addOption(accessKeyIdArg,
      abbr: 'a', valueHelp: accessKeyIdEnv, mandatory: false);
  argParser.addOption(secretAccessKeyArg,
      abbr: 's', valueHelp: secretAccessKeyEnv, mandatory: false);
  argParser.addOption(sessionTokenArg,
      abbr: 't', valueHelp: sessionTokenEnv, mandatory: false);
  argParser.addOption(userPoolIdArg,
      abbr: 'u', valueHelp: 'USER_POOL_ID', mandatory: true);
  argParser.addOption(
    regionArg,
    abbr: 'r',
    valueHelp: 'REGION',
    mandatory: true,
  );

  final pArgs = argParser.parse(args);
  final String? accessKeyId =
      Platform.environment[accessKeyIdEnv] ?? pArgs[accessKeyIdArg];
  final String? secretAccessKey =
      Platform.environment[secretAccessKeyEnv] ?? pArgs[secretAccessKeyArg];
  final String? sessionToken =
      Platform.environment[sessionTokenEnv] ?? pArgs[sessionTokenArg];

  if (accessKeyId == null || secretAccessKey == null) {
    stderr.writeln('No AWS credentials found');
    exit(1);
  }

  final userPoolId = pArgs[userPoolIdArg];
  final region = pArgs[regionArg];

  final AWSCredentials credentials =
      AWSCredentials(accessKeyId, secretAccessKey, sessionToken);
  final AWSCredentialScope scope =
      AWSCredentialScope(region: region, service: 'cognito-idp');
  final AWSSigV4Signer signer = AWSSigV4Signer(credentials);
  final List<int> body = utf8.encode(json.encode({
    'UserPoolId': userPoolId,
  }));
  final AWSHttpRequest sigRequest = AWSHttpRequest(
    httpMethod: HttpMethod.post,
    host: 'cognito-idp.$region.amazonaws.com',
    path: '/',
    headers: {
      AWSHeaders.target: 'AWSCognitoIdentityProviderService.DescribeUserPool',
      AWSHeaders.contentType: AWSHeaderValues.defaultContentType,
      AWSHeaders.contentLength: body.length.toString(),
    },
    body: body,
  );

  final AWSSigV4SignedRequest signedRequest =
      signer.sign(sigRequest, credentialScope: scope);
  final request = signedRequest.request;
  final resp = await request.send();
  print(resp.body);
}
