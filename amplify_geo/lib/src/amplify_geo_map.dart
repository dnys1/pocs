import 'dart:async';

import 'package:amplify_common/amplify_common.dart';
import 'package:amplify_geo/src/amplify_geo.dart';
import 'package:aws_cognito/aws_cognito.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart';
import 'package:vector_tile_renderer/src/logger.dart';

class AmplifyGeoMap extends StatefulWidget {
  const AmplifyGeoMap({
    Key? key,
    required this.config,
    this.center,
    this.zoom,
    this.customAttribution,
    this.dragPan,
    this.dragRotate,
    this.doubleClickZoom,
    this.hash,
    this.fadeDuration,
    this.failIfMajorPerformanceCaveat,
    this.interactive,
    this.keyboard,
  }) : super(key: key);

  final AmplifyConfig config;
  final LatLng? center;
  final double? zoom;
  final List<String>? customAttribution;
  final bool? dragPan;
  final bool? dragRotate;
  final bool? doubleClickZoom;
  final bool? hash;
  final int? fadeDuration;
  final bool? failIfMajorPerformanceCaveat;
  final bool? interactive;
  final bool? keyboard;

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
        var flags = InteractiveFlag.none;
        if (widget.interactive ?? false) {
          if (widget.dragPan ?? true) {
            flags |= InteractiveFlag.drag;
          }
          if (widget.doubleClickZoom ?? true) {
            flags |= InteractiveFlag.doubleTapZoom;
          }
          if (widget.dragRotate ?? true) {
            flags |= InteractiveFlag.rotate;
          }
        }
        final provider = AmplifyGeoProvider(credentials);
        const logger = ConsoleLogger();
        return FutureBuilder<Theme>(
            future: provider.getTheme(logger: logger),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text(snapshot.error!.toString()));
              } else if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return FlutterMap(
                options: MapOptions(
                  center: widget.center,
                  zoom: widget.zoom ?? 13,
                  interactiveFlags: flags,
                  plugins: [
                    VectorMapTilesPlugin(),
                  ],
                ),
                layers: [
                  VectorTileLayerOptions(
                    tileProvider: provider,
                    theme: snapshot.data!,
                    logCacheStats: true,
                    // showTileDebugInfo: true,
                  ),

                  // if (widget.center != null)
                  // MarkerLayerOptions(markers: [
                  //   Marker(point: widget.center!, builder: ),
                  // ]),
                ],
              );
            });
      },
    );
  }
}

class ConsoleLogger implements Logger {
  const ConsoleLogger();

  @override
  void log(MessageFunction message) {
    print(message());
  }

  @override
  void warn(MessageFunction message) {
    final t = message();
    print('WARN: $t');
  }
}
