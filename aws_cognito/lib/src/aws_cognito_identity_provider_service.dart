import 'dart:convert';

import 'package:aws_cognito/aws_cognito.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';

class AWSCognitoIdentityProviderService {
  static const serviceName = 'cognito-idp';

  final AWSSigV4Signer _signer;
  final String _region;

  AWSCognitoIdentityProviderService({
    required String region,
    AWSSigV4Signer? signer,
    AWSCredentials? credentials,
  })  : assert(
          signer != null || credentials != null,
          'Either an AWS signer or credentials must be provided.',
        ),
        _signer = signer ?? AWSSigV4Signer(credentials!),
        _region = region;

  Map<String, dynamic> _decode(String response) {
    return (jsonDecode(response) as Map).cast<String, dynamic>();
  }

  Future<UserPoolConfig> describeUserPool(String userPoolId) async {
    final AWSCredentialScope scope = AWSCredentialScope(
      region: _region,
      service: serviceName,
    );
    final List<int> body = json.encode({
      'UserPoolId': userPoolId,
    }).codeUnits;
    final AWSHttpRequest sigRequest = AWSHttpRequest(
      method: HttpMethod.post,
      host: '$serviceName.$_region.amazonaws.com',
      path: '/',
      headers: {
        AWSHeaders.contentType: AWSHeaderValues.defaultContentType,
        AWSHeaders.contentLength: body.length.toString(),
        AWSHeaders.target: 'AWSCognitoIdentityProviderService.DescribeUserPool',
      },
      body: body,
    );
    final AWSSignedRequest signedRequest = _signer.sign(
      AWSSignerRequest(
        sigRequest,
        credentialScope: scope,
      ),
    );

    final resp = await signedRequest.send();
    if (resp.statusCode != 200) {
      throw Exception(resp.body);
    }

    return UserPoolConfig.fromJson(_decode(resp.body));
  }

  Future<void> setDeviceTracking(
    String userPoolId,
    DeviceConfiguration? deviceConfiguration,
  ) async {
    final AWSCredentialScope scope = AWSCredentialScope(
      region: _region,
      service: serviceName,
    );
    final List<int> body = json.encode({
      'UserPoolId': userPoolId,
      'DeviceConfiguration': deviceConfiguration,
    }).codeUnits;
    final AWSHttpRequest sigRequest = AWSHttpRequest(
      method: HttpMethod.post,
      host: '$serviceName.$_region.amazonaws.com',
      path: '/',
      headers: {
        AWSHeaders.contentType: AWSHeaderValues.defaultContentType,
        AWSHeaders.contentLength: body.length.toString(),
        AWSHeaders.target: 'AWSCognitoIdentityProviderService.UpdateUserPool',
      },
      body: body,
    );
    final AWSSignedRequest signedRequest = _signer.sign(
      AWSSignerRequest(
        sigRequest,
        credentialScope: scope,
      ),
    );

    final resp = await signedRequest.send();
    if (resp.statusCode != 200) {
      throw Exception(resp.body);
    }
  }
}
