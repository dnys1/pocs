import 'package:amplify_common/amplify_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class AmplifyGeo {
  static final AmplifyGeo instance = AmplifyGeo._();

  AmazonLocationServicesPluginConfig? _config;

  AmplifyGeo._();

  void configure(AmazonLocationServicesPluginConfig config) {
    _config = config;
  }

  TransformRequestFunction getTransformRequestFunction(
    AWSCredentials credentials,
  ) {
    var config = _config;
    if (config == null) {
      throw StateError('Must call configure first');
    }
    final signer = AWSSigV4Signer(credentials);

    return (
      String url,
      ResourceType resourceType,
    ) {
      if (resourceType == ResourceType.style && !url.contains('://')) {
        url =
            'https://maps.geo.${config.region}.amazonaws.com/maps/v0/maps/$url/style-descriptor';
      }

      if (url.contains('amazonaws.com')) {
        final uri = Uri.parse(url);
        final signerRequest = AWSSignerRequest(
          AWSHttpRequest(
            method: HttpMethod.get,
            host: uri.host,
            path: uri.path,
            queryParameters: uri.queryParameters,
            headers: {
              AWSHeaders.host: uri.host,
            },
          ),
          credentialScope: AWSCredentialScope(
            region: config.region!,
            service: 'geo',
          ),
          presignedUrl: true,
        );
        final signedRequest = signer.sign(signerRequest);
        return {
          'url': signedRequest.toString(),
          'credentials': 'same-origin',
          'headers': <String, dynamic>{},
          'method': 'GET',
          'collectResourceTiming': false,
        };
      }
    };
  }
}
