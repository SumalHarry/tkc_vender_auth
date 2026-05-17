import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Explicit contract between the Core app and an embedded mini app.
///
/// Each mini app is adapted into a [MiniAppEntry] inside the Core app
/// (see the other files in `lib/app/mini_apps/`). The Core app never wires
/// a mini app's routes or widgets in directly — it only consumes this
/// interface and `miniAppRegistry`, so adding or removing a mini app
/// touches a single list.
abstract interface class MiniAppEntry {
  /// Stable identifier for the mini app. Also documents the route namespace.
  String get id;

  /// Title shown on the home launcher card.
  String get title;

  /// Supporting line shown on the home launcher card.
  String get subtitle;

  /// Icon shown on the home launcher card.
  IconData get icon;

  /// Accent colour for the home launcher card.
  Color get color;

  /// Path prefix every route of this mini app must live under, e.g.
  /// `/shopping`. Enforced by `assertMiniAppContract`.
  String get basePath;

  /// `name` of the route opened when the launcher card is tapped.
  String get entryRouteName;

  /// Routes contributed to the Core `GoRouter`.
  List<RouteBase> get routes;
}
