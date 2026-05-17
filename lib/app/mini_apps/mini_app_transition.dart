import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Rewrites a mini app's routes so every screen opens with a fade instead
/// of the default Material slide.
///
/// The first open of a mini app builds its whole widget tree and provider
/// graph on the same frame the page transition starts — a slide makes any
/// dropped frame obvious because widgets visibly jump. A fade only animates
/// opacity, so the same hitch is masked. Mini apps stay unaware of this:
/// they keep declaring plain `GoRoute`s with `builder`, and the Core App
/// adapts them here while composing the router.
List<RouteBase> withFadeTransition(List<RouteBase> routes) {
  return routes.map(_rewrite).toList();
}

RouteBase _rewrite(RouteBase route) {
  if (route is! GoRoute) return route;

  final builder = route.builder;
  return GoRoute(
    path: route.path,
    name: route.name,
    redirect: route.redirect,
    parentNavigatorKey: route.parentNavigatorKey,
    routes: route.routes.map(_rewrite).toList(),
    pageBuilder: builder == null
        ? null
        : (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              child: builder(context, state),
              transitionsBuilder: (context, animation, _, child) =>
                  FadeTransition(opacity: animation, child: child),
            ),
  );
}
