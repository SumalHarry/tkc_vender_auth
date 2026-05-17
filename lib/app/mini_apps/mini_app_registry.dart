import 'package:go_router/go_router.dart';
import 'package:tkc_vender_auth/app/mini_apps/configs/concert_mini_app.dart';
import 'package:tkc_vender_auth/app/mini_apps/mini_app_entry.dart';
import 'package:tkc_vender_auth/app/mini_apps/configs/shopping_mini_app.dart';

/// Single source of truth for the mini apps embedded in the Core app.
///
/// Adding a mini app means: write a `MiniAppEntry` adapter and add it here.
/// The router and the home launcher both derive from this list.
const List<MiniAppEntry> miniAppRegistry = <MiniAppEntry>[
  ShoppingMiniApp(),
  ConcertMiniApp(),
];

/// Fails fast (in debug builds) when mini apps violate the contract:
/// duplicate ids/namespaces, or top-level routes that escape their
/// declared [MiniAppEntry.basePath]. Call once while building the router.
void assertMiniAppContract() {
  assert(() {
    final seenIds = <String>{};
    final seenPaths = <String>{};
    for (final app in miniAppRegistry) {
      if (!seenIds.add(app.id)) {
        throw StateError('Duplicate mini app id: "${app.id}".');
      }
      if (!seenPaths.add(app.basePath)) {
        throw StateError('Duplicate mini app basePath: "${app.basePath}".');
      }
      for (final route in app.routes) {
        if (route is GoRoute && !route.path.startsWith(app.basePath)) {
          throw StateError(
            'Mini app "${app.id}" exposes route "${route.path}" outside '
            'its declared namespace "${app.basePath}".',
          );
        }
      }
    }
    return true;
  }());
}
