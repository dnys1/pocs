import 'dart:convert';
import 'dart:typed_data';

import 'package:amplify_common/amplify_common.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';
import 'package:http/http.dart' as http;
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart';

class AmplifyGeo {
  static final AmplifyGeo instance = AmplifyGeo._();

  AmazonLocationServicesPluginConfig? _config;

  AmplifyGeo._();

  void configure(AmazonLocationServicesPluginConfig config) {
    _config = config;
  }
}

class AmplifyGeoProvider extends VectorTileProvider {
  AmplifyGeoProvider(AWSCredentials credentials)
      : _signer = AWSSigV4Signer(credentials),
        _client = http.Client();

  final AWSSigV4Signer _signer;
  final http.Client _client;

  @override
  int get maximumZoom => 14;

  @override
  Future<Uint8List> provide(TileIdentity tile) async {
    var config = AmplifyGeo.instance._config;
    if (config == null) {
      throw StateError('Must call AmplifyGeo.instance.configure first');
    }
    final host = 'maps.geo.${config.region}.amazonaws.com';
    final signerRequest = AWSSignerRequest(
      AWSHttpRequest(
        method: HttpMethod.get,
        host: host,
        path: '/maps/v0/maps/${config.maps!.$default}/tiles/${tile.z}/${tile.x}/${tile.y}',
        headers: {
          AWSHeaders.host: host,
        },
      ),
      credentialScope: AWSCredentialScope(
        region: config.region!,
        service: 'geo',
      ),
      presignedUrl: true,
    );
    final signedRequest = _signer.sign(signerRequest);
    final response = await signedRequest.send(_client);
    return response.bodyBytes;
  }

  Future<Theme> getTheme({Logger? logger}) async {
    var config = AmplifyGeo.instance._config;
    if (config == null) {
      throw StateError('Must call AmplifyGeo.instance.configure first');
    }
    final host = 'maps.geo.${config.region}.amazonaws.com';
    final signerRequest = AWSSignerRequest(
      AWSHttpRequest(
        method: HttpMethod.get,
        host: host,
        path: '/maps/v0/maps/${config.maps!.$default}/style-descriptor',
        headers: {
          AWSHeaders.host: host,
        },
      ),
      credentialScope: AWSCredentialScope(
        region: config.region!,
        service: 'geo',
      ),
      presignedUrl: true,
    );
    final signedRequest = _signer.sign(signerRequest);
    final response = await signedRequest.send(_client);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final theme = ThemeReader(logger: logger).read(json);
    return theme;
  }
}
