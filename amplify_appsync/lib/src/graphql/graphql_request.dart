import 'package:amplify_common/amplify_common.dart';
import 'package:meta/meta.dart';

@immutable
class GraphQLRequest with AmplifySerializable, AmplifyEquatable {
  final String query;
  final Map<String, dynamic> variables;
  final String? operationName;

  const GraphQLRequest(
    this.query, {
    this.variables = const <String, dynamic>{},
    this.operationName,
  });

  @override
  List<Object?> get props => [query, variables, operationName];

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'query': query,
        'variables': variables,
        if (operationName != null) 'operationName': operationName,
      };
}
