import 'package:tkc_vender_auth/core/network/models/app_exception.dart';
import 'package:tkc_vender_auth/core/network/models/either.dart';
import 'package:tkc_vender_auth/core/network/models/unit.dart';
import 'package:tkc_vender_auth/core/storage/secure_storage.dart';
import 'package:tkc_vender_auth/features/auth/domain/entities/auth_tokens.dart';

abstract class AuthLocalDataSource {
  Future<Either<AppException, Unit>> saveTokens(AuthTokens tokens);
  Future<Either<AppException, AuthTokens?>> readTokens();
  Future<Either<AppException, Unit>> clearTokens();
  Future<bool> hasSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._storage);

  final SecureStorageService _storage;

  @override
  Future<Either<AppException, Unit>> saveTokens(AuthTokens tokens) async {
    try {
      await _storage.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
        accessTokenExpiresAt:
            tokens.accessTokenExpiresAt.toUtc().toIso8601String(),
        refreshTokenExpiresAt:
            tokens.refreshTokenExpiresAt.toUtc().toIso8601String(),
      );
      return const Right(unit);
    } catch (error) {
      return Left(AppException(error.toString()));
    }
  }

  @override
  Future<Either<AppException, AuthTokens?>> readTokens() async {
    try {
      final accessToken = await _storage.accessToken;
      final refreshToken = await _storage.refreshToken;
      final accessTokenExpiresAt = await _storage.accessTokenExpiresAt;
      final refreshTokenExpiresAt = await _storage.refreshTokenExpiresAt;
      if (accessToken == null ||
          refreshToken == null ||
          accessTokenExpiresAt == null ||
          refreshTokenExpiresAt == null) {
        return const Right(null);
      }
      return Right(
        AuthTokens(
          accessToken: accessToken,
          accessTokenExpiresAt: DateTime.parse(accessTokenExpiresAt),
          refreshToken: refreshToken,
          refreshTokenExpiresAt: DateTime.parse(refreshTokenExpiresAt),
        ),
      );
    } catch (error) {
      return Left(AppException(error.toString()));
    }
  }

  @override
  Future<Either<AppException, Unit>> clearTokens() async {
    try {
      await _storage.clearTokens();
      return const Right(unit);
    } catch (error) {
      return Left(AppException(error.toString()));
    }
  }

  @override
  Future<bool> hasSession() async {
    final accessToken = await _storage.accessToken;
    return accessToken != null && accessToken.isNotEmpty;
  }
}
