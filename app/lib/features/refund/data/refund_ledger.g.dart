// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refund_ledger.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Возвраты, оформленные на этом телефоне в концепт-режиме.
///
/// Живут только в памяти: после перезапуска приложения пропадают.
/// Бэк о них не знает, поэтому история и сводка накладывают их поверх
/// ответов сервера (см. [apply]).

@ProviderFor(RefundLedger)
final refundLedgerProvider = RefundLedgerProvider._();

/// Возвраты, оформленные на этом телефоне в концепт-режиме.
///
/// Живут только в памяти: после перезапуска приложения пропадают.
/// Бэк о них не знает, поэтому история и сводка накладывают их поверх
/// ответов сервера (см. [apply]).
final class RefundLedgerProvider
    extends $NotifierProvider<RefundLedger, Map<String, List<Refund>>> {
  /// Возвраты, оформленные на этом телефоне в концепт-режиме.
  ///
  /// Живут только в памяти: после перезапуска приложения пропадают.
  /// Бэк о них не знает, поэтому история и сводка накладывают их поверх
  /// ответов сервера (см. [apply]).
  RefundLedgerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refundLedgerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refundLedgerHash();

  @$internal
  @override
  RefundLedger create() => RefundLedger();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, List<Refund>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, List<Refund>>>(value),
    );
  }
}

String _$refundLedgerHash() => r'aee0badf9210257a02d40470b6e4415f1a861f5b';

/// Возвраты, оформленные на этом телефоне в концепт-режиме.
///
/// Живут только в памяти: после перезапуска приложения пропадают.
/// Бэк о них не знает, поэтому история и сводка накладывают их поверх
/// ответов сервера (см. [apply]).

abstract class _$RefundLedger extends $Notifier<Map<String, List<Refund>>> {
  Map<String, List<Refund>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<Map<String, List<Refund>>, Map<String, List<Refund>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, List<Refund>>, Map<String, List<Refund>>>,
              Map<String, List<Refund>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
