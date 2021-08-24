import 'dart:convert';

import 'package:aws_cognito/src/model/get_credentials_for_identity_request.dart';
import 'package:aws_cognito/src/model/get_credentials_for_identity_response.dart';
import 'package:aws_cognito/src/model/get_id_request.dart';
import 'package:aws_cognito/src/model/get_id_response.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';

class AWSCognitoIdentityService {
  static const serviceName = 'cognito-identity';

  final AWSSigV4Signer? _signer;
  final String _region;

  const AWSCognitoIdentityService({
    required String region,
    AWSSigV4Signer? signer,
    AWSCredentials? credentials,
  })  : _signer = signer,
        _region = region;

  Future<GetIdResponse> getId({required String identityPoolId}) async {
    final GetIdRequest request = GetIdRequest(identityPoolId: identityPoolId);
    final List<int> body = jsonEncode(request).codeUnits;
    final AWSHttpRequest httpRequest = AWSHttpRequest(
      method: HttpMethod.post,
      host: '$serviceName.$_region.amazonaws.com',
      path: '/',
      headers: {
        AWSHeaders.contentType: AWSHeaderValues.defaultContentType,
        AWSHeaders.contentLength: body.length.toString(),
        AWSHeaders.target: 'AWSCognitoIdentityService.GetId',
      },
      body: body,
    );

    final resp = await httpRequest.send();
    if (resp.statusCode != 200) {
      throw Exception(resp.body);
    }

    return GetIdResponse.fromJson(
      jsonDecode(resp.body) as Map<String, dynamic>,
    );
  }

  Future<GetCredentialsForIdentityResponse> getCredentialsForIdentity(
    String identityId,
  ) async {
    final GetCredentialsForIdentityRequest request =
        GetCredentialsForIdentityRequest(identityId: identityId);
    final List<int> body = jsonEncode(request).codeUnits;
    final AWSHttpRequest httpRequest = AWSHttpRequest(
      method: HttpMethod.post,
      host: '$serviceName.$_region.amazonaws.com',
      path: '/',
      headers: {
        AWSHeaders.contentType: AWSHeaderValues.defaultContentType,
        AWSHeaders.contentLength: body.length.toString(),
        AWSHeaders.target:
            'AWSCognitoIdentityService.GetCredentialsForIdentity',
      },
      body: body,
    );

    final resp = await httpRequest.send();
    if (resp.statusCode != 200) {
      throw Exception(resp.body);
    }

    return GetCredentialsForIdentityResponse.fromJson(
      jsonDecode(resp.body) as Map<String, dynamic>,
    );
  }
}
