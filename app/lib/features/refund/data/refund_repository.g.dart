// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refund_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `null` — возвраты в этой сборке выключены.

@ProviderFor(refundRepository)
final refundRepositoryProvider = RefundRepositoryProvider._();

/// `null` — возвраты в этой сборке выключены.

final class RefundRepositoryProvider
    extends
        $FunctionalProvider<
          RefundRepository?,
          RefundRepository?,
          RefundRepository?
        >
    with $Provider<RefundRepository?> {
  /// `null` — возвраты в этой сборке выключены.
  RefundRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refundRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refundRepositoryHash();

  @$internal
  @override
  $ProviderElement<RefundRepository?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RefundRepository? create(Ref ref) {
    return refundRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RefundRepository? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RefundRepository?>(value),
    );
  }
}

String _$refundRepositoryHash() => r'6e677fbdc4efe123fae4f2c517dc114c093c61b4';
