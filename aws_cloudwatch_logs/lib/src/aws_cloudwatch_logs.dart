import 'dart:convert';

import 'package:aws_signature_v4/aws_signature_v4.dart';

import 'models/log_stream.dart';

class AWSCloudWatchLogsService {
  static const serviceName = 'logs';

  final AWSSigV4Signer _signer;
  final String _region;

  const AWSCloudWatchLogsService({
    required String region,
    AWSSigV4Signer? signer,
    AWSCredentials? credentials,
  })  : _signer = signer ?? const AWSSigV4Signer(),
        _region = region;

  Future<void> createLogStream(CreateLogStreamInput input) async {
    final List<int> body = jsonEncode(input).codeUnits;
    final AWSCredentialScope scope = AWSCredentialScope(
      region: _region,
      service: serviceName,
    );
    final AWSHttpRequest httpRequest = AWSHttpRequest(
      method: HttpMethod.post,
      host: '$serviceName.$_region.amazonaws.com',
      path: '/',
      headers: {
        AWSHeaders.contentType: AWSHeaderValues.defaultContentType,
        AWSHeaders.contentLength: body.length.toString(),
        AWSHeaders.target: 'Logs_20140328.CreateLogStream',
      },
      body: body,
    );
    final AWSSignedRequest signedRequest = await _signer.sign(
      httpRequest,
      credentialScope: scope,
    );

    final resp = await signedRequest.send();
    if (resp.statusCode != 200) {
      throw Exception(resp.body);
    }
  }

  Future<PutLogEventsResponse> putLogEvents(PutLogEventsRequest input) async {
    final List<int> body = jsonEncode(input).codeUnits;
    final AWSCredentialScope scope = AWSCredentialScope(
      region: _region,
      service: serviceName,
    );
    final AWSHttpRequest httpRequest = AWSHttpRequest(
      method: HttpMethod.post,
      host: '$serviceName.$_region.amazonaws.com',
      path: '/',
      headers: {
        AWSHeaders.contentType: AWSHeaderValues.defaultContentType,
        AWSHeaders.contentLength: body.length.toString(),
        AWSHeaders.target: 'Logs_20140328.PutLogEvents',
      },
      body: body,
    );
    final AWSSignedRequest signedRequest = await _signer.sign(
      httpRequest,
      credentialScope: scope,
    );

    final resp = await signedRequest.send();
    if (resp.statusCode != 200) {
      throw Exception(resp.body);
    }

    return PutLogEventsResponse.fromJson(jsonDecode(resp.body));
  }
}
