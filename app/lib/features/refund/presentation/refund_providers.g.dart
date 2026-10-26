// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refund_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Возвраты платежа, оформленные на этом телефоне (концепт).

@ProviderFor(paymentRefunds)
final paymentRefundsProvider = PaymentRefundsFamily._();

/// Возвраты платежа, оформленные на этом телефоне (концепт).

final class PaymentRefundsProvider
    extends $FunctionalProvider<List<Refund>, List<Refund>, List<Refund>>
    with $Provider<List<Refund>> {
  /// Возвраты платежа, оформленные на этом телефоне (концепт).
  PaymentRefundsProvider._({
    required PaymentRefundsFamily super.from,
    required Payment super.argument,
  }) : super(
         retry: null,
         name: r'paymentRefundsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$paymentRefundsHash();

  @override
  String toString() {
    return r'paymentRefundsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Refund>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Refund> create(Ref ref) {
    final argument = this.argument as Payment;
    return paymentRefunds(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Refund> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Refund>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PaymentRefundsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$paymentRefundsHash() => r'4393d63d076877bd0aaa260d6e9d8f13be2ed138';

/// Возвраты платежа, оформленные на этом телефоне (концепт).

final class PaymentRefundsFamily extends $Family
    with $FunctionalFamilyOverride<List<Refund>, Payment> {
  PaymentRefundsFamily._()
    : super(
        retry: null,
        name: r'paymentRefundsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Возвраты платежа, оформленные на этом телефоне (концепт).

  PaymentRefundsProvider call(Payment payment) =>
      PaymentRefundsProvider._(argument: payment, from: this);

  @override
  String toString() => r'paymentRefundsProvider';
}

/// Платёж, каким его видит мерчант: ответ бэка плюс возвраты с телефона.

@ProviderFor(effectivePayment)
final effectivePaymentProvider = EffectivePaymentFamily._();

/// Платёж, каким его видит мерчант: ответ бэка плюс возвраты с телефона.

final class EffectivePaymentProvider
    extends $FunctionalProvider<Payment, Payment, Payment>
    with $Provider<Payment> {
  /// Платёж, каким его видит мерчант: ответ бэка плюс возвраты с телефона.
  EffectivePaymentProvider._({
    required EffectivePaymentFamily super.from,
    required Payment super.argument,
  }) : super(
         retry: null,
         name: r'effectivePaymentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$effectivePaymentHash();

  @override
  String toString() {
    return r'effectivePaymentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Payment> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Payment create(Ref ref) {
    final argument = this.argument as Payment;
    return effectivePayment(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Payment value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Payment>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is EffectivePaymentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$effectivePaymentHash() => r'e8a6145ca6886bacbc2f8c1a913e2248b6af0288';

/// Платёж, каким его видит мерчант: ответ бэка плюс возвраты с телефона.

final class EffectivePaymentFamily extends $Family
    with $FunctionalFamilyOverride<Payment, Payment> {
  EffectivePaymentFamily._()
    : super(
        retry: null,
        name: r'effectivePaymentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Платёж, каким его видит мерчант: ответ бэка плюс возвраты с телефона.

  EffectivePaymentProvider call(Payment payment) =>
      EffectivePaymentProvider._(argument: payment, from: this);

  @override
  String toString() => r'effectivePaymentProvider';
}

/// Активна ли кнопка «Возврат платежа».

@ProviderFor(refundAvailable)
final refundAvailableProvider = RefundAvailableFamily._();

/// Активна ли кнопка «Возврат платежа».

final class RefundAvailableProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Активна ли кнопка «Возврат платежа».
  RefundAvailableProvider._({
    required RefundAvailableFamily super.from,
    required Payment super.argument,
  }) : super(
         retry: null,
         name: r'refundAvailableProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$refundAvailableHash();

  @override
  String toString() {
    return r'refundAvailableProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as Payment;
    return refundAvailable(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RefundAvailableProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$refundAvailableHash() => r'e8848efccc284921dca0d0bfd069b4395205f13f';

/// Активна ли кнопка «Возврат платежа».

final class RefundAvailableFamily extends $Family
    with $FunctionalFamilyOverride<bool, Payment> {
  RefundAvailableFamily._()
    : super(
        retry: null,
        name: r'refundAvailableProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Активна ли кнопка «Возврат платежа».

  RefundAvailableProvider call(Payment payment) =>
      RefundAvailableProvider._(argument: payment, from: this);

  @override
  String toString() => r'refundAvailableProvider';
}
