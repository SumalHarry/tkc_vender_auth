import 'package:tkc_vender_auth/core/domain/entities/user.dart';
import 'package:tkc_vender_auth/core/network/models/app_exception.dart';
import 'package:tkc_vender_auth/core/network/models/either.dart';
import 'package:tkc_vender_auth/core/network/models/unit.dart';
import 'package:tkc_vender_auth/core/network/network_service.dart';

abstract class ProfileRemoteDataSource {
  Future<Either<AppException, User>> getProfile();

  Future<Either<AppException, Unit>> registerDevice({
    required String deviceId,
    required String fcmToken,
  });

  Future<Either<AppException, Unit>> unregisterDevice({
    required String deviceId,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl(this._networkService);

  final NetworkService _networkService;

  @override
  Future<Either<AppException, User>> getProfile() async {
    final result = await _networkService.get('/account/profile');
    return result.fold(
      Left.new,
      (response) => Right(User.fromJson(response.data)),
    );
  }

  @override
  Future<Either<AppException, Unit>> registerDevice({
    required String deviceId,
    required String fcmToken,
  }) async {
    final result = await _networkService.post(
      '/devices',
      data: {'deviceId': deviceId, 'fcmToken': fcmToken},
    );
    return result.fold(Left.new, (_) => const Right(unit));
  }

  @override
  Future<Either<AppException, Unit>> unregisterDevice({
    required String deviceId,
  }) async {
    final result = await _networkService.delete(
      '/devices',
      data: {'deviceId': deviceId},
    );
    return result.fold(Left.new, (_) => const Right(unit));
  }
}
