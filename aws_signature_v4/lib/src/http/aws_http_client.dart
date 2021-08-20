import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:aws_signature_v4/src/credentials/aws_credentials.dart';
import 'package:aws_signature_v4/src/request/aws_sig_v4_signed_request.dart';
import 'package:http/http.dart' as http;

class AWSHttpClient extends http.BaseClient {
  final AWSSigV4Signer _signer;
  final http.Client _baseClient;

  AWSHttpClient({
    required AWSCredentials credentials,
    http.Client? baseClient,
  })  : _baseClient = baseClient ?? http.Client(),
        _signer = AWSSigV4Signer(
          credentials,
          algorithm: AWSAlgorithm.hmacSha256,
        );

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final http.ByteStream byteStream = request.finalize();
    final List<int> bodyBytes = await byteStream.toBytes();
    final AWSHttpRequest sigRequest = AWSHttpRequest.fromHttpRequest(
      request,
      body: bodyBytes,
    );
    final List<String> hostComponents = request.url.authority.split('.');
    final String service = hostComponents[0];
    final String region = hostComponents[1];
    final AWSSigV4SignedRequest signedRequest = _signer.sign(
      sigRequest,
      credentialScope: AWSCredentialScope(region: region, service: service),
    );
    return _baseClient.send(signedRequest.request.toHttpRequest());
  }
}
