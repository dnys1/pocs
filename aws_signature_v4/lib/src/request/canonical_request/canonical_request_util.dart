part of 'canonical_request.dart';

/// Decodes a query parameter if it's encoded.
String _decodeIfNeeded(String queryComponent) {
  return queryComponent.contains('%')
      ? Uri.decodeComponent(queryComponent)
      : queryComponent;
}
