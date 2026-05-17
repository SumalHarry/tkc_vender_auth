import 'package:equatable/equatable.dart';

class AppException extends Equatable implements Exception {
  const AppException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'AppException($message, code: $code)';
}
