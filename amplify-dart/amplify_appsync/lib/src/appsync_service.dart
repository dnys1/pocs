import 'dart:convert';

import 'package:amplify_appsync/src/model/list_graphql_apis_input.dart';
import 'package:amplify_appsync/src/model/list_graphql_apis_output.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';

class AWSAppSyncService {
  static const serviceName = 'appsync';

  final AWSSigV4Signer _signer;
  final String _region;

  AWSAppSyncService({
    required String region,
    AWSSigV4Signer? signer,
    AWSCredentials? credentials,
  })  : assert(
          signer != null || credentials != null,
          'Either an AWS signer or credentials must be provided.',
        ),
        _signer = signer ?? AWSSigV4Signer(credentials!),
        _region = region;

  Future<ListGraphqlApisOutput> listGraphQLApis(
    ListGraphqlApisInput input,
  ) async {
    final AWSCredentialScope scope = AWSCredentialScope(
      region: _region,
      service: serviceName,
    );
    final AWSHttpRequest request = AWSHttpRequest(
      method: HttpMethod.get,
      host: '$serviceName.$_region.amazonaws.com',
      path: '/v1/apis',
      queryParameters: input.toJson().map((key, dynamic value) {
        return MapEntry(key, value.toString());
      }),
    );
    final AWSSigV4SignedRequest signedRequest =
        _signer.sign(request, credentialScope: scope);

    final resp = await signedRequest.send();
    if (resp.statusCode != 200) {
      throw Exception(resp.body);
    }

    return ListGraphqlApisOutput.fromJson(
      jsonDecode(resp.body) as Map<String, dynamic>,
    );
  }
}
