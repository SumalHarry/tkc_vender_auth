import 'package:tkc_vender_auth/core/network/models/app_exception.dart';
import 'package:tkc_vender_auth/core/network/models/either.dart';
import 'package:tkc_vender_auth/core/network/network_service.dart';
import 'package:tkc_vender_auth/features/auth/domain/entities/auth_tokens.dart';

abstract class AuthRemoteDataSource {
  Future<Either<AppException, AuthTokens>> login({
    required String username,
    required String password,
  });

  Future<Either<AppException, AuthTokens>> refresh({
    required String refreshToken,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._networkService);

  final NetworkService _networkService;

  @override
  Future<Either<AppException, AuthTokens>> login({
    required String username,
    required String password,
  }) async {
    final result = await _networkService.post(
      '/auth/login',
      data: {'username': username, 'password': password},
    );
    return result.fold(
      Left.new,
      (response) => Right(AuthTokens.fromJson(response.data)),
    );
  }

  @override
  Future<Either<AppException, AuthTokens>> refresh({
    required String refreshToken,
  }) async {
    final result = await _networkService.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
    );
    return result.fold(
      Left.new,
      (response) => Right(AuthTokens.fromJson(response.data)),
    );
  }
}
