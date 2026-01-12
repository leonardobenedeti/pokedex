import 'package:dio/dio.dart';

import '../error/error_messages.dart';
import '../error/exceptions.dart';

class NetworkInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return handler.next(
        DioException(
          requestOptions: err.requestOptions,
          error: ConnectionException(message: ErrorMessages.connectionError),
          type: DioExceptionType.unknown,
        ),
      );
    }
    return super.onError(err, handler);
  }
}
