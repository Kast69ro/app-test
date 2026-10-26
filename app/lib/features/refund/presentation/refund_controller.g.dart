// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refund_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Возврат одного платежа. Деньги уходят со счёта мерчанта, поэтому
/// перед запросом спрашиваем код входа (ошибки — в общий счётчик 5 попыток).

@ProviderFor(RefundController)
final refundControllerProvider = RefundControllerFamily._();

/// Возврат одного платежа. Деньги уходят со счёта мерчанта, поэтому
/// перед запросом спрашиваем код входа (ошибки — в общий счётчик 5 попыток).
final class RefundControllerProvider
    extends $NotifierProvider<RefundController, RefundState> {
  /// Возврат одного платежа. Деньги уходят со счёта мерчанта, поэтому
  /// перед запросом спрашиваем код входа (ошибки — в общий счётчик 5 попыток).
  RefundControllerProvider._({
    required RefundControllerFamily super.from,
    required Payment super.argument,
  }) : super(
         retry: null,
         name: r'refundControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$refundControllerHash();

  @override
  String toString() {
    return r'refundControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RefundController create() => RefundController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RefundState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RefundState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RefundControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$refundControllerHash() => r'0e459263dc188584db795a8fc72c583423abdb68';

/// Возврат одного платежа. Деньги уходят со счёта мерчанта, поэтому
/// перед запросом спрашиваем код входа (ошибки — в общий счётчик 5 попыток).

final class RefundControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          RefundController,
          RefundState,
          RefundState,
          RefundState,
          Payment
        > {
  RefundControllerFamily._()
    : super(
        retry: null,
        name: r'refundControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Возврат одного платежа. Деньги уходят со счёта мерчанта, поэтому
  /// перед запросом спрашиваем код входа (ошибки — в общий счётчик 5 попыток).

  RefundControllerProvider call(Payment payment) =>
      RefundControllerProvider._(argument: payment, from: this);

  @override
  String toString() => r'refundControllerProvider';
}

/// Возврат одного платежа. Деньги уходят со счёта мерчанта, поэтому
/// перед запросом спрашиваем код входа (ошибки — в общий счётчик 5 попыток).

abstract class _$RefundController extends $Notifier<RefundState> {
  late final _$args = ref.$arg as Payment;
  Payment get payment => _$args;

  RefundState build(Payment payment);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RefundState, RefundState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RefundState, RefundState>,
              RefundState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
