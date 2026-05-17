import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tkc_vender_auth/app/mini_apps/mini_app_registry.dart';
import 'package:tkc_vender_auth/app/mini_apps/mini_app_transition.dart';
import 'package:tkc_vender_auth/app/router/app_routes.dart';
import 'package:tkc_vender_auth/features/auth/presentation/providers/auth_notifier.dart';
import 'package:tkc_vender_auth/features/auth/presentation/providers/auth_state.dart';
import 'package:tkc_vender_auth/features/auth/presentation/screens/auth_screen.dart';
import 'package:tkc_vender_auth/features/home/presentation/screens/home_screen.dart';
import 'package:tkc_vender_auth/features/splash/presentation/screens/splash_screen.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

const _publicPaths = {AppRoutes.splashPath, AppRoutes.authPath};

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  assertMiniAppContract();

  final authListenable = ValueNotifier<AuthState>(ref.read(authProvider));

  ref.listen(authProvider, (_, next) {
    authListenable.value = next;
  });

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splashPath,
    refreshListenable: authListenable,
    redirect: (context, state) {
      final authState = authListenable.value;
      final isPublic = _publicPaths.contains(state.matchedLocation);

      if (authState.state == AuthConcreteState.initial) return null;

      if (authState.state == AuthConcreteState.unauthenticated && !isPublic) {
        return AppRoutes.authPath;
      }

      return null;
    },
    routes: [
      GoRoute(
        name: AppRoutes.splash,
        path: AppRoutes.splashPath,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: SplashScreen()),
      ),
      GoRoute(
        name: AppRoutes.auth,
        path: AppRoutes.authPath,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: AuthScreen()),
      ),
      GoRoute(
        name: AppRoutes.home,
        path: AppRoutes.homePath,
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: HomeScreen()),
      ),
      for (final app in miniAppRegistry) ...withFadeTransition(app.routes),
    ],
  );
}
