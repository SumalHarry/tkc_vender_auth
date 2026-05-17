import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniapp_concert/miniapp_concert.dart';
import 'package:miniapp_shopping/miniapp_shopping.dart';
import 'package:tkc_vender_auth/app/router/app_router.dart';
import 'package:tkc_vender_auth/app/theme/app_theme.dart';
import 'package:tkc_vender_auth/core/constants/debug_config.dart';
import 'package:tkc_vender_auth/core/network/providers/network_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  setupProxymanIfEnabled();

  final container = ProviderContainer(
    overrides: [
      concertDioProvider.overrideWith((ref) => ref.watch(coreDioProvider)),
      shoppingDioProvider.overrideWith((ref) => ref.watch(coreDioProvider)),
    ],
  );

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const VendorAuthApp(),
    ),
  );
}

class VendorAuthApp extends ConsumerWidget {
  const VendorAuthApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Vendor Auth',
      theme: AppTheme.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
