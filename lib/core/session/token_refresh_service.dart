import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_refresh_service.g.dart';

typedef TokenRefreshCallback = Future<void> Function();

/// Broadcast point for "a new access token was just stored".
/// [AuthRefreshInterceptor] calls [notifyRefreshed] after saving fresh tokens;
/// [WebSocketService] registers [onRefreshed] to reconnect with the new token.
@Riverpod(keepAlive: true)
class TokenRefreshService extends _$TokenRefreshService {
  final List<TokenRefreshCallback> _listeners = [];

  @override
  void build() {}

  void register(TokenRefreshCallback callback) {
    _listeners.add(callback);
  }

  void unregister(TokenRefreshCallback callback) {
    _listeners.remove(callback);
  }

  Future<void> notifyRefreshed() async {
    for (final listener in List.of(_listeners)) {
      await listener();
    }
  }
}
