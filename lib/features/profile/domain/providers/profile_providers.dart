import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tkc_vender_auth/core/network/providers/network_providers.dart';
import 'package:tkc_vender_auth/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:tkc_vender_auth/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:tkc_vender_auth/features/profile/domain/repositories/profile_repository.dart';

part 'profile_providers.g.dart';

@Riverpod(keepAlive: true)
ProfileRemoteDataSource profileRemoteDataSource(Ref ref) {
  return ProfileRemoteDataSourceImpl(ref.watch(coreNetworkServiceProvider));
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepositoryImpl(ref.watch(profileRemoteDataSourceProvider));
}
