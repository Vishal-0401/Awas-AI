import 'api_error.dart';

class BaseResponse {
  final bool success;
  final String message;

  const BaseResponse({
    required this.success,
    required this.message,
  });
}

class ApiResponse<T> extends BaseResponse {
  final T? data;
  final ApiError? error;

  const ApiResponse({
    required super.success,
    required super.message,
    this.data,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? dataParser,
  ) {
    final success = json['success'] == true;
    final message = (json['message'] as String?) ?? '';

    if (success) {
      final rawData = json['data'];
      final parsedData = dataParser == null ? rawData as T? : dataParser(rawData);
      return ApiResponse<T>(
        success: true,
        message: message,
        data: parsedData,
      );
    }

    final rawErr = json['error'];
    final errMap = rawErr is Map<String, dynamic> ? rawErr : null;
    return ApiResponse<T>(
      success: false,
      message: message,
      data: null,
      error: errMap == null ? null : ApiError.fromJson(errMap),
    );
  }
}

