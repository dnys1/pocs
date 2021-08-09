import 'package:amplify_common/amplify_common.dart';

/// Contains an error produced via a GraphQL invocation. Corresponds to one
/// entry in the `errors` field on a GraphQL response.
///
/// [locations] and [path] may be null.
class GraphQLResponseError {
  /// The description of the error.
  final String message;

  /// The locations of the error-causing fields in the request document.
  final List<GraphQLResponseErrorLocation>? locations;

  /// The key path of the error-causing field in the response's `data` object.
  final List<dynamic>? path;

  const GraphQLResponseError({
    required this.message,
    this.locations,
    this.path,
  });

  Map<String, dynamic> toJson() => {
        'message': message,
        if (locations != null) 'locations': locations,
        if (path != null) 'path': path,
      };

  @override
  String toString() {
    return 'GraphQLResponseError${prettyPrintJson(this)}';
  }
}

/// Represents a location in the GraphQL request document where an error occurred.
/// [line] and [column] correspond to the beginning of the syntax element associated
/// with the error.
class GraphQLResponseErrorLocation {
  /// The line in the GraphQL request document where the error-causing syntax
  /// element starts.
  final int line;

  /// The column in the GraphQL request document where the error-causing syntax
  /// element starts.
  final int column;

  const GraphQLResponseErrorLocation(this.line, this.column);

  Map<String, dynamic> toJson() => {
        'line': line,
        'column': column,
      };
}
