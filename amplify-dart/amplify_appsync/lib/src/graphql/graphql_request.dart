class GraphQLRequest {
  final String query;
  final Map<String, dynamic> variables;

  const GraphQLRequest(this.query, {this.variables = const {}});

  Map<String, dynamic> toJson() => {
        'query': query,
        'variables': variables,
      };
}
