import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logout_service.g.dart';

typedef LogoutHandler = Future<void> Function();

@Riverpod(keepAlive: true)
class LogoutService extends _$LogoutService {
  LogoutHandler? _handler;

  void register(LogoutHandler handler) {
    _handler = handler;
  }

  Future<void> logout() async {
    await _handler?.call();
  }

  @override
  void build() {}
}
