import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miniapp_shopping/miniapp_shopping.dart';
import 'package:tkc_vender_auth/app/mini_apps/mini_app_entry.dart';
import 'package:tkc_vender_auth/app/theme/app_colors.dart';

/// Core-side adapter that wraps the `miniapp_shopping` package as a
/// [MiniAppEntry]. The mini app itself stays unaware of the Core app.
class ShoppingMiniApp implements MiniAppEntry {
  const ShoppingMiniApp();

  @override
  String get id => 'shopping';

  @override
  String get title => 'Shopping';

  @override
  String get subtitle => 'Browse & order products';

  @override
  IconData get icon => Icons.shopping_bag_rounded;

  @override
  Color get color => AppColors.shoppingBlue;

  @override
  String get basePath => '/shopping';

  @override
  String get entryRouteName => ShoppingRouteNames.list;

  @override
  List<RouteBase> get routes => shoppingRoutes;
}
