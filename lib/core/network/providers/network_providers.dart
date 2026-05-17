import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tkc_vender_auth/core/network/default_api_base_options.dart';
import 'package:tkc_vender_auth/core/network/dio_network_service.dart';
import 'package:tkc_vender_auth/core/network/interceptors/auth_refresh_interceptor.dart';
import 'package:tkc_vender_auth/core/network/interceptors/header_interceptor.dart';
import 'package:tkc_vender_auth/core/network/interceptors/log_interceptor.dart';
import 'package:tkc_vender_auth/core/network/interceptors/retry_interceptor.dart';
import 'package:tkc_vender_auth/core/network/network_service.dart';
import 'package:tkc_vender_auth/core/storage/secure_storage.dart';
import 'package:tkc_vender_auth/core/session/logout_service.dart';
import 'package:tkc_vender_auth/core/session/token_refresh_service.dart';

part 'network_providers.g.dart';

@Riverpod(keepAlive: true)
Dio coreDio(Ref ref) {
  final storage = ref.watch(secureStorageServiceProvider);
  final dio = Dio(defaultApiBaseOptions());
  final refreshDio = Dio(defaultApiBaseOptions());

  dio.interceptors.addAll([
    NetworkLogInterceptor(),
    AuthRefreshInterceptor(
      storage: storage,
      refreshDio: refreshDio,
      onLogout: () => ref.read(logoutServiceProvider.notifier).logout(),
      onTokenRefreshed: () =>
          ref.read(tokenRefreshServiceProvider.notifier).notifyRefreshed(),
    ),
    HeaderInterceptor(storage),
    RetryInterceptor(dio: dio),
  ]);

  return dio;
}

@Riverpod(keepAlive: true)
NetworkService coreNetworkService(Ref ref) {
  return DioNetworkService(ref.watch(coreDioProvider));
}
