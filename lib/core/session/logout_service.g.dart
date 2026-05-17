// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logout_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LogoutService)
final logoutServiceProvider = LogoutServiceProvider._();

final class LogoutServiceProvider
    extends $NotifierProvider<LogoutService, void> {
  LogoutServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logoutServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logoutServiceHash();

  @$internal
  @override
  LogoutService create() => LogoutService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$logoutServiceHash() => r'7ef0e2d0ca996e26241221f7353c20af28ff930b';

abstract class _$LogoutService extends $Notifier<void> {
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
