import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  RetryInterceptor({required Dio dio, this.maxRetries = 3}) : _dio = dio;

  final Dio _dio;
  final int maxRetries;
  static const _retryDelays = [
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 5),
  ];

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRetry(err)) {
      handler.next(err);
      return;
    }

    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;
    if (retryCount >= maxRetries) {
      handler.next(err);
      return;
    }

    await Future<void>.delayed(
      _retryDelays[retryCount.clamp(0, _retryDelays.length - 1)],
    );

    try {
      final options = err.requestOptions;
      options.extra['retryCount'] = retryCount + 1;
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  bool _shouldRetry(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode == 401 ||
        statusCode == 403 ||
        statusCode == 404 ||
        statusCode == 400) {
      return false;
    }
    if (statusCode != null && statusCode >= 500) return true;
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError;
  }
}
