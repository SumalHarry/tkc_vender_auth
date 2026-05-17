import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tkc_vender_auth/core/session/logout_service.dart';
import 'package:tkc_vender_auth/core/storage/secure_storage.dart';
import 'package:tkc_vender_auth/features/auth/domain/providers/auth_providers.dart';
import 'package:tkc_vender_auth/features/auth/presentation/providers/auth_state.dart';
import 'package:tkc_vender_auth/features/profile/domain/providers/profile_providers.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    ref.read(logoutServiceProvider.notifier).register(logout);
    _restoreSession();
    return const AuthState.initial();
  }

  Future<void> _restoreSession() async {
    final hasSession = await ref.read(authRepositoryProvider).hasSession();
    if (!hasSession) {
      state = state.copyWith(state: AuthConcreteState.unauthenticated);
      return;
    }

    final storage = ref.read(secureStorageServiceProvider);
    final accessExpiresAt = await storage.accessTokenExpiresAt;
    final refreshExpiresAt = await storage.refreshTokenExpiresAt;

    final accessValid =
        accessExpiresAt != null && _isTokenValid(accessExpiresAt);
    final refreshValid =
        refreshExpiresAt != null && _isTokenValid(refreshExpiresAt);

    if (!accessValid && !refreshValid) {
      await ref.read(authRepositoryProvider).logout();
      state = state.copyWith(state: AuthConcreteState.unauthenticated);
      return;
    }

    state = state.copyWith(state: AuthConcreteState.authenticated);
    fetchProfile();
  }

  bool _isTokenValid(String isoDateString) {
    final expiry = DateTime.tryParse(isoDateString);
    if (expiry == null) return false;
    return DateTime.now().isBefore(
      expiry.subtract(const Duration(seconds: 30)),
    );
  }

  Future<bool> fetchProfile() async {
    final profileResult = await ref
        .read(profileRepositoryProvider)
        .getProfile();
    return profileResult.fold((_) => false, (user) {
      state = state.copyWith(user: user);
      return true;
    });
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      state: AuthConcreteState.loading,
      message: '',
    );

    final result = await ref
        .read(authRepositoryProvider)
        .login(username: username, password: password);

    result.fold(
      (error) {
        state = state.copyWith(
          isLoading: false,
          state: AuthConcreteState.failure,
          message: error.message,
        );
      },
      (_) {
        state = state.copyWith(
          isLoading: false,
          state: AuthConcreteState.authenticated,
        );
      },
    );
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState(state: AuthConcreteState.unauthenticated);
  }
}
