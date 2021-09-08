import 'package:amplify_appsync/src/config/appsync_config.dart';
import 'package:amplify_appsync/src/ws/websocket_connection_header.dart';
import 'package:amplify_common/amplify_common.dart';
import 'package:test/test.dart';

const apiKey = AppSyncApiKeyAuthorization('da2-12345678901234567890123456');
final apiKeyConfig = AppSyncConfig(
  graphQLUri: Uri.parse(
      'https://example1234567890000.appsync-api.us-east-1.amazonaws.com/graphql'),
  realTimeGraphQLUri: Uri.parse(
      'wss://example1234567890000.appsync-realtime-api.us-east-1.amazonaws.com/graphql'),
  authorization: apiKey,
);
final apiKeyHeader = WebSocketConnectionHeader(apiKeyConfig);

void main() {
  group('encode', () {
    test('API_KEY', () async {
      final expectedJson = {
        'host': 'example1234567890000.appsync-api.us-east-1.amazonaws.com',
        'x-api-key': 'da2-12345678901234567890123456',
      };
      const expectedBase64 =
          'eyJob3N0IjoiZXhhbXBsZTEyMzQ1Njc4OTAwMDAuYXBwc3luYy1hcGkudXMtZWFzdC0xLmFtYXpvbmF3cy5jb20iLCJ4LWFwaS1rZXkiOiJkYTItMTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTYifQ==';
      expect(await apiKeyHeader.toJson(), equals(expectedJson));
      expect(await apiKeyHeader.encode(), equals(expectedBase64));
    });
  });
}
