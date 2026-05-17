import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tkc_vender_auth/core/network/providers/network_providers.dart';
import 'package:tkc_vender_auth/core/storage/secure_storage.dart';
import 'package:tkc_vender_auth/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:tkc_vender_auth/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:tkc_vender_auth/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:tkc_vender_auth/features/auth/domain/repositories/auth_repository.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSourceImpl(ref.watch(coreNetworkServiceProvider));
}

@Riverpod(keepAlive: true)
AuthLocalDataSource authLocalDataSource(Ref ref) {
  return AuthLocalDataSourceImpl(ref.watch(secureStorageServiceProvider));
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
}
