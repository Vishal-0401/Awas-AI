import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/api_error.dart';
import '../models/api_response.dart';

class ApiException implements Exception {
  final ApiError error;
  final String message;

  ApiException({required this.error, required this.message});

  @override
  String toString() => 'ApiException($message, ${error.code})';
}

class ApiClient {
  final String baseUrl;

  const ApiClient({required this.baseUrl});

  Future<ApiResponse<T>> getJson<T>(
    String path, {
    Map<String, String>? query,
    T Function(Object? json)? dataParser,
    bool requiresAuth = false,
  }) {
    return _sendJson<T>(
      'GET',
      path,
      query: query,
      body: null,
      dataParser: dataParser,
      requiresAuth: requiresAuth,
    );
  }

  Future<ApiResponse<T>> postJson<T>(
    String path, {
    Object? body,
    T Function(Object? json)? dataParser,
    bool requiresAuth = false,
  }) {
    return _sendJson<T>(
      'POST',
      path,
      body: body,
      dataParser: dataParser,
      requiresAuth: requiresAuth,
    );
  }

  Future<ApiResponse<T>> _sendJson<T>(
    String method,
    String path, {
    Map<String, String>? query,
    Object? body,
    T Function(Object? json)? dataParser,
    bool requiresAuth = false,
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (requiresAuth) 'Authorization': await _getAuthHeader(),
    };

    final logPrefix = '[API] $method $uri';
    debugPrint(logPrefix);
    if (body != null) {
      debugPrint('$logPrefix body=${jsonEncode(body)}');
    }

    final request = http.Request(method, uri);
    request.headers.addAll(headers);
    if (body != null) {
      request.body = jsonEncode(body);
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);


    debugPrint('$logPrefix status=${response.statusCode}');

    final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : <String, dynamic>{};

    if (decoded is! Map<String, dynamic>) {
      // Non-conformant payload
      return ApiResponse<T>(
        success: false,
        message: 'Invalid server response',
        data: null,
        error: ApiError(code: response.statusCode, details: decoded.toString()),
      );
    }

    final api = ApiResponse<T>.fromJson(decoded, dataParser);

    if (!api.success) {
      throw ApiException(
        error: api.error ?? ApiError(code: response.statusCode, details: null),
        message: api.message,
      );
    }

    return api;
  }

  Future<String> _getAuthHeader() async {
    final box = await Hive.openBox('authBox');
    final token = box.get('accessToken');
    if (token == null || token is! String || token.isEmpty) {
      return '';
    }
    return 'Bearer $token';
  }
}

