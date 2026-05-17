import 'package:equatable/equatable.dart';
import 'package:tkc_vender_auth/core/domain/entities/user.dart';

enum AuthConcreteState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  failure,
}

class AuthState extends Equatable {
  const AuthState({
    this.user,
    this.state = AuthConcreteState.initial,
    this.message = '',
    this.isLoading = false,
  });

  const AuthState.initial()
    : user = null,
      state = AuthConcreteState.initial,
      message = '',
      isLoading = false;

  final User? user;
  final AuthConcreteState state;
  final String message;
  final bool isLoading;

  bool get isAuthenticated =>
      state == AuthConcreteState.authenticated && user != null;

  AuthState copyWith({
    User? user,
    AuthConcreteState? state,
    String? message,
    bool? isLoading,
  }) {
    return AuthState(
      user: user ?? this.user,
      state: state ?? this.state,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [user, state, message, isLoading];
}
