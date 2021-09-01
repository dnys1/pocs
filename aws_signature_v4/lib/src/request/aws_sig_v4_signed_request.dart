import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:aws_signature_v4/src/request/canonical_request/canonical_request.dart';

export 'package:aws_signature_v4/src/request/http_method.dart';

/// {@template aws_sig_v4_signed_request}
/// A signed [AWSHttpRequest].
/// {@endtemplate}
class AWSSigV4SignedRequest extends AWSHttpRequest {
  /// The canonical request for this request.
  final CanonicalRequest canonicalRequest;

  /// The signature for this request.
  final String signature;

  /// @{macro aws_sig_v4_signed_request}
  AWSSigV4SignedRequest({
    required this.canonicalRequest,
    required this.signature,
    required HttpMethod method,
    required String host,
    required String path,
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    List<int>? body,
  }) : super(
          method: method,
          host: host,
          path: path,
          queryParameters: queryParameters,
          headers: headers,
          body: body,
        );

  @override
  List<Object> get props => [
        method,
        host,
        path,
        queryParameters,
        headers,
        body,
        canonicalRequest,
        signature,
      ];
}
