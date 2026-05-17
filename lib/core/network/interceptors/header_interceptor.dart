import 'package:dio/dio.dart';
import 'package:tkc_vender_auth/core/storage/secure_storage.dart';

class HeaderInterceptor extends Interceptor {
  HeaderInterceptor(this._storage);

  final SecureStorageService _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
