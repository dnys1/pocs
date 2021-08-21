import 'package:amplify_appsync/src/config/appsync_config.dart';
import 'package:amplify_appsync/src/ws/websocket_connection_header.dart';
import 'package:amplify_common/amplify_common.dart';
import 'package:test/test.dart';

const apiKey = ApiKeyAuthorization('da2-12345678901234567890123456');
final apiKeyConfig = AppSyncConfig(
  graphQLUri: Uri.parse(
      'https://example1234567890000.appsync-api.us-east-1.amazonaws.com/graphql'),
  realTimeGraphQLUri: Uri.parse(
      'wss://example1234567890000.appsync-realtime-api.us-east-1.amazonaws.com/graphql'),
  authorization: apiKey,
);
final apiKeyHeader = WebSocketConnectionHeader(
  host: 'example1234567890000.appsync-api.us-east-1.amazonaws.com',
  authorization: apiKey,
);

void main() {
  group('fromConfig', () {
    test('API_KEY', () {
      final header = WebSocketConnectionHeader.fromConfig(apiKeyConfig);
      expect(header, apiKeyHeader);
    });
  });

  group('encode', () {
    test('API_KEY', () {
      final expectedJson = {
        'host': 'example1234567890000.appsync-api.us-east-1.amazonaws.com',
        'x-api-key': 'da2-12345678901234567890123456',
      };
      final expectedBase64 =
          'eyJob3N0IjoiZXhhbXBsZTEyMzQ1Njc4OTAwMDAuYXBwc3luYy1hcGkudXMtZWFzdC0xLmFtYXpvbmF3cy5jb20iLCJ4LWFwaS1rZXkiOiJkYTItMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTYifQ==';
      expect(apiKeyHeader.toJson(), equals(expectedJson));
      expect(apiKeyHeader.encode(), equals(expectedBase64));
    });
  });
}
