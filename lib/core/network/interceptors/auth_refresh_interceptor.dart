import 'dart:async';

import 'package:dio/dio.dart';
import 'package:tkc_vender_auth/core/storage/secure_storage.dart';

typedef LogoutCallback = Future<void> Function();
typedef TokenRefreshedCallback = Future<void> Function();

class AuthRefreshInterceptor extends Interceptor {
  AuthRefreshInterceptor({
    required SecureStorageService storage,
    required Dio refreshDio,
    required LogoutCallback onLogout,
    TokenRefreshedCallback? onTokenRefreshed,
  }) : _storage = storage,
       _refreshDio = refreshDio,
       _onLogout = onLogout,
       _onTokenRefreshed = onTokenRefreshed;

  final SecureStorageService _storage;
  final Dio _refreshDio;
  final LogoutCallback _onLogout;
  final TokenRefreshedCallback? _onTokenRefreshed;

  bool _isRefreshing = false;
  Completer<String>? _refreshCompleter;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Refreshes the access token into storage when expired. The actual
      // `Authorization` header is attached downstream by [HeaderInterceptor],
      // which reads the (now valid) token from storage.
      await _ensureValidAccessToken();
      handler.next(options);
    } catch (_) {
      await _onLogout();
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
          message: 'Session expired',
        ),
      );
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    try {
      final token = await _ensureValidAccessToken();
      if (token.isEmpty) {
        handler.next(err);
        return;
      }

      final response = await _retryRequest(err.requestOptions, token);
      handler.resolve(response);
    } catch (_) {
      await _onLogout();
      handler.next(err);
    }
  }

  Future<String> _ensureValidAccessToken() async {
    final accessToken = await _storage.accessToken;
    final accessExpiresAt = await _storage.accessTokenExpiresAt;

    if (accessToken == null || accessToken.isEmpty) {
      return '';
    }

    if (accessExpiresAt != null && !_isExpired(accessExpiresAt)) {
      return accessToken;
    }

    return _refreshAccessToken();
  }

  Future<String> _refreshAccessToken() async {
    if (_isRefreshing) {
      return _refreshCompleter!.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<String>();

    try {
      final refreshExpiresAt = await _storage.refreshTokenExpiresAt;
      if (refreshExpiresAt == null || _isExpired(refreshExpiresAt)) {
        throw StateError('Refresh token expired');
      }

      final refreshToken = await _storage.refreshToken;
      if (refreshToken == null || refreshToken.isEmpty) {
        throw StateError('No refresh token');
      }

      final response = await _refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final data = response.data;
      final newAccessToken = data?['accessToken'] as String?;
      final newRefreshToken = data?['refreshToken'] as String?;
      final newAccessTokenExpiresAt = data?['accessTokenExpiresAt'] as String?;
      final newRefreshTokenExpiresAt = data?['refreshTokenExpiresAt'] as String?;
      if (newAccessToken == null ||
          newAccessToken.isEmpty ||
          newRefreshToken == null ||
          newRefreshToken.isEmpty ||
          newAccessTokenExpiresAt == null ||
          newRefreshTokenExpiresAt == null) {
        throw StateError('Invalid refresh response');
      }

      await _storage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
        accessTokenExpiresAt: newAccessTokenExpiresAt,
        refreshTokenExpiresAt: newRefreshTokenExpiresAt,
      );

      _refreshCompleter!.complete(newAccessToken);
      unawaited(_onTokenRefreshed?.call());
      return newAccessToken;
    } catch (error, stackTrace) {
      _refreshCompleter!.completeError(error, stackTrace);
      rethrow;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }

  Future<Response<dynamic>> _retryRequest(
    RequestOptions requestOptions,
    String token,
  ) {
    return _refreshDio.fetch<dynamic>(
      requestOptions.copyWith(
        headers: {...requestOptions.headers, 'Authorization': 'Bearer $token'},
      ),
    );
  }

  bool _isExpired(String isoDateString) {
    final expiry = DateTime.tryParse(isoDateString);
    if (expiry == null) return true;
    return DateTime.now().isAfter(expiry.subtract(const Duration(seconds: 30)));
  }
}
