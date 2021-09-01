import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:aws_signature_v4/src/services/configuration.dart';
import 'package:aws_signature_v4/src/services/validator.dart';

class S3ServiceConfiguration extends BaseServiceConfiguration {
  final bool signedPayload;

  const S3ServiceConfiguration({
    this.signedPayload = true,
  }) : super(
          normalizePath: false,
          omitSessionToken: false,
        );

  @override
  void apply(
    Map<String, String> base,
    CanonicalRequest canonicalRequest, {
    required AWSCredentials credentials,
  }) {
    super.apply(base, canonicalRequest, credentials: credentials);

    if (signedPayload) {
      base.putIfAbsent(
        AWSHeaders.contentSHA256,
        () => canonicalRequest.hashedPayload,
      );
    } else {
      base[AWSHeaders.contentSHA256] = 'UNSIGNED-PAYLOAD';
    }

    // if (request.method.hasBody) {
    //   base.putIfAbsent(AWSHeaders.contentType, () => AWSHeaderValues.defaultContentType,);
    // }

    // base.addAll({
    //   if (request.method.hasBody &&
    //       !base.containsKey(AWSHeaders.contentType))
    //     AWSHeaders.contentType: AWSHeaderValues.defaultContentType,
    //   if (request.httpMethod.hasBody &&
    //       !params.containsKey(AWSHeaders.contentLength))
    //   AWSHeaders.contentLength: request.body.length.toString(),
    // })
  }
}

class S3ServiceHeader extends ServiceHeader {
  const S3ServiceHeader._(
    String key,
    Validator<String> valueValidator,
  ) : super(key, valueValidator);

  static S3ServiceHeader asciiMetadata(String metadata) => S3ServiceHeader._(
        'x-amz-meta-ascii',
        Validator.regExp(r'^[\x00-\x7F]*$'),
      );

  static S3ServiceHeader nonAsciiMetadata(String metadata) => S3ServiceHeader._(
        'x-amz-meta-nonascii',
        Validator.any(),
      );

  static const contentSha256 = S3ServiceHeader._(
    AWSHeaders.contentSHA256,
    Validator.oneOf([
      Validator.value('UNSIGNED-PAYLOAD'),
      Validator.value('STREAMING-AWS4-HMAC-SHA256-PAYLOAD'),

      // TODO: Hex signature validator
      Validator.regExp(r'.*')
    ]),
  );
}
