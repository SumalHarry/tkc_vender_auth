import 'package:tkc_vender_auth/core/network/models/app_exception.dart';
import 'package:tkc_vender_auth/core/network/models/either.dart';
import 'package:tkc_vender_auth/core/network/models/unit.dart';
import 'package:tkc_vender_auth/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:tkc_vender_auth/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:tkc_vender_auth/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<Either<AppException, bool>> login({
    required String username,
    required String password,
  }) async {
    final loginResult = await _remoteDataSource.login(
      username: username,
      password: password,
    );

    return loginResult.fold(Left.new, (tokens) async {
      final saveResult = await _localDataSource.saveTokens(tokens);
      return saveResult.fold(Left.new, (_) => const Right(true));
    });
  }

  @override
  Future<Either<AppException, Unit>> logout() async {
    return _localDataSource.clearTokens();
  }

  @override
  Future<bool> hasSession() => _localDataSource.hasSession();
}
