import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:miniapp_concert/miniapp_concert.dart';
import 'package:tkc_vender_auth/app/mini_apps/mini_app_entry.dart';
import 'package:tkc_vender_auth/app/theme/app_colors.dart';

/// Core-side adapter that wraps the `miniapp_concert` package as a
/// [MiniAppEntry]. The mini app itself stays unaware of the Core app.
class ConcertMiniApp implements MiniAppEntry {
  const ConcertMiniApp();

  @override
  String get id => 'concert';

  @override
  String get title => 'Concert';

  @override
  String get subtitle => 'Book concert tickets';

  @override
  IconData get icon => Icons.confirmation_number_outlined;

  @override
  Color get color => AppColors.concertYellow;

  @override
  String get basePath => '/concert';

  @override
  String get entryRouteName => ConcertRouteNames.list;

  @override
  List<RouteBase> get routes => concertRoutes;
}
