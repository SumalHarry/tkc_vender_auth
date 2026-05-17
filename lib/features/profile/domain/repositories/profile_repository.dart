import 'package:tkc_vender_auth/core/domain/entities/user.dart';
import 'package:tkc_vender_auth/core/network/models/app_exception.dart';
import 'package:tkc_vender_auth/core/network/models/either.dart';
import 'package:tkc_vender_auth/core/network/models/unit.dart';

abstract class ProfileRepository {
  Future<Either<AppException, User>> getProfile();

  Future<Either<AppException, Unit>> registerDevice({
    required String deviceId,
    required String fcmToken,
  });

  Future<Either<AppException, Unit>> unregisterDevice({
    required String deviceId,
  });
}
