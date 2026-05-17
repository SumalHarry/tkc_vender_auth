import 'package:tkc_vender_auth/core/domain/entities/user.dart';
import 'package:tkc_vender_auth/core/network/models/app_exception.dart';
import 'package:tkc_vender_auth/core/network/models/either.dart';
import 'package:tkc_vender_auth/core/network/models/unit.dart';
import 'package:tkc_vender_auth/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:tkc_vender_auth/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Either<AppException, User>> getProfile() =>
      _remoteDataSource.getProfile();

  @override
  Future<Either<AppException, Unit>> registerDevice({
    required String deviceId,
    required String fcmToken,
  }) =>
      _remoteDataSource.registerDevice(deviceId: deviceId, fcmToken: fcmToken);

  @override
  Future<Either<AppException, Unit>> unregisterDevice({
    required String deviceId,
  }) =>
      _remoteDataSource.unregisterDevice(deviceId: deviceId);
}
