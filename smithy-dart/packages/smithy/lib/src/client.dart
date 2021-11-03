import 'package:http/http.dart' as http;

abstract class Client {
  const Client();
}

class HttpClient extends http.BaseClient implements Client {
  HttpClient({
    required this.baseUri,
    http.Client? baseClient,
  }) : baseClient = baseClient ?? http.Client();

  final http.Client baseClient;
  final Uri baseUri;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return baseClient.send(request);
  }
}
