// ignore_for_file: file_names

import 'package:crypto_app/src/core/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiRequest {
  static final _dio = ApiService().dio;

  static Future<Response?> getRequest(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return response;
    } on DioException catch (e) {
      _handleError(e);
      rethrow;
    }
  }

  // // POST request method
  // static Future<Response?> postRequest(String path, {dynamic data}) async {
  //   try {
  //     final response = await _dio.post(path, data: data);
  //     return response;
  //   } on DioException catch (e) {
  //     _handleError(e);
  //     rethrow;
  //   }
  // }

  // Error handling method
  static void _handleError(DioException error) {
    String errorMessage = 'An error occurred';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Connection timeout';
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = 'Send timeout';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Receive timeout';
        break;
      case DioExceptionType.badResponse:
        errorMessage = 'Bad response: ${error.response?.statusCode}';
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request canceled';
        break;
      case DioExceptionType.unknown:
        errorMessage = error.message ?? 'Unknown error';
        break;
      default:
        errorMessage = 'Network error';
    }

    debugPrint('DIO ERROR: $errorMessage');
    // You could also log to a service like Firebase Crashlytics here
  }
}
