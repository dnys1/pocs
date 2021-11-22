import 'dart:convert';

import 'package:aws_pinpoint/src/models/endpoint.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';

class AWSPinpointService {
  static const serviceName = 'pinpoint';

  final AWSSigV4Signer _signer;
  final String _region;

  const AWSPinpointService({
    required String region,
    AWSSigV4Signer? signer,
    AWSCredentials? credentials,
  })  : _signer = signer ?? const AWSSigV4Signer(),
        _region = region;

  Future<EndpointResponse> getEndpoint(UpdateEndpointInput input) async {
    final body = jsonEncode(input).codeUnits;
    final AWSCredentialScope scope = AWSCredentialScope(
      region: _region,
      service: 'mobiletargeting',
    );
    final AWSHttpRequest sigRequest = AWSHttpRequest(
      method: HttpMethod.put,
      host: '$serviceName.$_region.amazonaws.com',
      path: '/v1/apps/${input.applicationId}/endpoints/${input.endpointId}',
      headers: {
        AWSHeaders.contentType: AWSHeaderValues.defaultContentType,
        AWSHeaders.contentLength: body.length.toString(),
      },
      body: body,
    );
    final AWSSignedRequest signedRequest = await _signer.sign(
      sigRequest,
      credentialScope: scope,
    );

    final resp = await signedRequest.send();
    if (resp.statusCode != 202) {
      throw Exception(resp.body);
    }

    return EndpointResponse.fromJson(jsonDecode(resp.body));
  }
}
