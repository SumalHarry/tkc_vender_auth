class ParseResponse<T> {
  const ParseResponse({
    required this.data,
    required this.page,
    required this.limit,
    required this.total,
  });

  final T data;
  final int page;
  final int limit;
  final int total;

  factory ParseResponse.fromMap(
    Map<String, dynamic> json, {
    required T Function(dynamic json) modifier,
  }) {
    return ParseResponse(
      data: modifier(json['data']),
      page: _asInt(json['page']),
      limit: _asInt(json['limit']),
      total: _asInt(json['total']),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
