class ApiError {
  final int code;
  final String? details;

  const ApiError({
    required this.code,
    this.details,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: (json['code'] as num?)?.toInt() ?? 0,
      details: json['details'] as String?,
    );
  }
}

