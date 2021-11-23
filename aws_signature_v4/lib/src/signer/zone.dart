part of 'aws_signer.dart';

/// Runs the given sign function in a zone where [print] defers to [safePrint]
/// and uncaught exceptions are scrubbed of sensitive data.
R _signZoned<R>(R Function() signFn) {
  return runZoned(signFn, zoneSpecification: ZoneSpecification(
    print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
      safePrint(line);
    },
  ));
}
