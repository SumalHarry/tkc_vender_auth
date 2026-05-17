import 'package:tkc_vender_auth/core/network/models/app_exception.dart';
import 'package:tkc_vender_auth/core/network/models/either.dart';
import 'package:tkc_vender_auth/core/network/models/unit.dart';

abstract class AuthRepository {
  Future<Either<AppException, bool>> login({
    required String username,
    required String password,
  });

  Future<Either<AppException, Unit>> logout();

  Future<bool> hasSession();
}
