import 'dart:async';

import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_geo/src/amplify_geo.dart';
import 'package:aws_cognito/aws_cognito.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class AmplifyGeoMap extends StatefulWidget {
  const AmplifyGeoMap({
    Key? key,
    required this.config,
    this.center,
    this.zoom,
  }) : super(key: key);

  final AmplifyConfig config;
  final Coordinates? center;
  final int? zoom;

  @override
  State<AmplifyGeoMap> createState() => _AmplifyGeoMapState();
}

class _AmplifyGeoMapState extends State<AmplifyGeoMap> {
  static const _idpSerivce = AWSCognitoIdentityService(
    region: 'us-west-2',
  );
  final Completer<AWSCredentials> _credentials = Completer();

  late final AmazonLocationServicesPluginConfig _config;

  @override
  void initState() {
    super.initState();
    _config = widget.config.geo!.awsPlugin!;
    AmplifyGeo.instance.configure(_config);
    _getCredentials();
  }

  Future<void> _getCredentials() async {
    try {
      final getIdRequest = await _idpSerivce.getId(
        identityPoolId: widget.config.auth!.cognitoPlugin!.credentialsProvider!
            .cognitoIdentity!.$default!.poolId,
      );
      final response =
          await _idpSerivce.getCredentialsForIdentity(getIdRequest.identityId);
      final credentials = response.credentials;
      _credentials.complete(AWSCredentials(
        credentials.accessKeyId!,
        credentials.secretKey!,
        credentials.sessionToken,
      ));
    } catch (e) {
      _credentials.completeError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AWSCredentials>(
      future: _credentials.future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error!.toString()));
        } else if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final credentials = snapshot.data!;
        return MaplibreMap(
          center: widget.center,
          zoom: widget.zoom,
          style: _config.maps!.$default,
          transformRequestFunction:
              AmplifyGeo.instance.getTransformRequestFunction(credentials),
        );
      },
    );
  }
}
