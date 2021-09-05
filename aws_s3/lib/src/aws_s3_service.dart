import 'package:aws_signature_v4/aws_signature_v4.dart';

abstract class AWSS3ServiceInterface {
  static const serviceName = 's3';

  final AWSSigV4Signer? _signer;
  final String _region;

  const AWSS3ServiceInterface({
    required String region,
    AWSSigV4Signer? signer,
    AWSCredentials? credentials,
  })  : _signer = signer,
        _region = region;

  Future<void> putFile({
    required String bucket,
    required String key,
    
  })
}