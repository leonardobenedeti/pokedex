import 'package:dio/dio.dart';

import 'network_interceptor.dart';

abstract class NetworkClient {
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  });
}

class DioClient implements NetworkClient {
  final Dio _dio;

  static const duration = Duration(seconds: 10);

  DioClient(this._dio) {
    _dio.interceptors.add(NetworkInterceptor());
    _dio.options.connectTimeout = duration;
    _dio.options.receiveTimeout = duration;
  }

  @override
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
