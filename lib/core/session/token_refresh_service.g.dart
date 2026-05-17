// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_refresh_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Broadcast point for "a new access token was just stored".
/// [AuthRefreshInterceptor] calls [notifyRefreshed] after saving fresh tokens;
/// [WebSocketService] registers [onRefreshed] to reconnect with the new token.

@ProviderFor(TokenRefreshService)
final tokenRefreshServiceProvider = TokenRefreshServiceProvider._();

/// Broadcast point for "a new access token was just stored".
/// [AuthRefreshInterceptor] calls [notifyRefreshed] after saving fresh tokens;
/// [WebSocketService] registers [onRefreshed] to reconnect with the new token.
final class TokenRefreshServiceProvider
    extends $NotifierProvider<TokenRefreshService, void> {
  /// Broadcast point for "a new access token was just stored".
  /// [AuthRefreshInterceptor] calls [notifyRefreshed] after saving fresh tokens;
  /// [WebSocketService] registers [onRefreshed] to reconnect with the new token.
  TokenRefreshServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenRefreshServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenRefreshServiceHash();

  @$internal
  @override
  TokenRefreshService create() => TokenRefreshService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$tokenRefreshServiceHash() =>
    r'2541f28d5715f3291a3182de7f79182a025b485e';

/// Broadcast point for "a new access token was just stored".
/// [AuthRefreshInterceptor] calls [notifyRefreshed] after saving fresh tokens;
/// [WebSocketService] registers [onRefreshed] to reconnect with the new token.

abstract class _$TokenRefreshService extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
