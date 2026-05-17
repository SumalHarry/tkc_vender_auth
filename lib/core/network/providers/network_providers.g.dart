// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(coreDio)
final coreDioProvider = CoreDioProvider._();

final class CoreDioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  CoreDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coreDioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coreDioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return coreDio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$coreDioHash() => r'418c535e36f7014bef69a55b286d6e09d08ac15f';

@ProviderFor(coreNetworkService)
final coreNetworkServiceProvider = CoreNetworkServiceProvider._();

final class CoreNetworkServiceProvider
    extends $FunctionalProvider<NetworkService, NetworkService, NetworkService>
    with $Provider<NetworkService> {
  CoreNetworkServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coreNetworkServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coreNetworkServiceHash();

  @$internal
  @override
  $ProviderElement<NetworkService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NetworkService create(Ref ref) {
    return coreNetworkService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkService>(value),
    );
  }
}

String _$coreNetworkServiceHash() =>
    r'c42923abf13f18f4da78a3425a98759221a69575';
