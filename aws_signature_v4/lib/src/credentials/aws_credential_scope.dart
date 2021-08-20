import 'package:aws_signature_v4/src/request/aws_date_time.dart';
import 'package:aws_signature_v4/src/signer/signer.dart';

/// The scope for a set of credentials, used to identify a request.
class AWSCredentialScope {
  final AWSDateTime dateTime;
  final String region;
  final String service;

  AWSCredentialScope({
    AWSDateTime? dateTime,
    required this.region,
    required this.service,
  }) : dateTime = dateTime ?? AWSDateTime.now();

  @override
  String toString() =>
      '${dateTime.formatDate()}/$region/$service/${AWSSigV4Signer.terminationString}';
}
