import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/api/api_exception.dart';
import '../../auth/presentation/session_controller.dart';
import '../../history/presentation/history_controller.dart';
import '../../home/presentation/home_providers.dart';
import '../../payment/domain/payment.dart';
import '../../pin/data/pin_repository.dart';
import '../../pin/presentation/pin_controller.dart';
import '../data/refund_repository.dart';
import '../domain/refund.dart';

part 'refund_controller.freezed.dart';
part 'refund_controller.g.dart';

/// Сумма и причина → код входа → запрос → итог.
enum RefundStage { form, pin, sending, done }

@freezed
abstract class RefundState with _$RefundState {
  const factory RefundState({
    @Default(RefundStage.form) RefundStage stage,
    @Default(0) int amountCents,
    String? reason,
    @Default('') String pin,
    @Default(false) bool pinBusy,
    PinError? pinError,

    /// Ошибка запроса — показывается на форме.
    Object? error,
    Refund? result,
  }) = _RefundState;
}

/// Возврат одного платежа. Деньги уходят со счёта мерчанта, поэтому
/// перед запросом спрашиваем код входа (ошибки — в общий счётчик 5 попыток).
@riverpod
class RefundController extends _$RefundController {
  @override
  RefundState build(Payment payment) => const RefundState();

  /// Сумма уже проверена на экране — дальше подтверждение кодом.
  void submit(int amountCents, String? reason) {
    if (state.stage != RefundStage.form) return;
    final text = reason?.trim();
    state = RefundState(
      stage: RefundStage.pin,
      amountCents: amountCents,
      reason: (text == null || text.isEmpty) ? null : text,
    );
  }

  /// «← Назад» с экрана кода — к форме, введённое не теряется.
  void backToForm() {
    if (state.stage != RefundStage.pin) return;
    state = state.copyWith(
      stage: RefundStage.form,
      pin: '',
      pinBusy: false,
      pinError: null,
    );
  }

  void key(String? digit) {
    if (state.stage != RefundStage.pin || state.pinBusy) return;
    if (digit == null) {
      if (state.pin.isEmpty) return;
      state = state.copyWith(
        pin: state.pin.substring(0, state.pin.length - 1),
        pinError: null,
      );
      return;
    }
    if (state.pin.length >= pinLength) return;
    final next = state.pin + digit;
    state = state.copyWith(pin: next, pinError: null);
    if (next.length == pinLength) {
      state = state.copyWith(pinBusy: true);
      // Пауза — чтобы успела закраситься последняя точка.
      Future.delayed(const Duration(milliseconds: 120), () {
        if (ref.mounted) _checkPin(next);
      });
    }
  }

  Future<void> _checkPin(String pin) async {
    final result = await ref
        .read(sessionControllerProvider.notifier)
        .verifyPin(pin);
    if (!ref.mounted) return;
    switch (result) {
      case PinOk():
        await _send();
      case PinWrong(:final attemptsLeft):
        state = state.copyWith(
          pin: '',
          pinBusy: false,
          pinError: PinWrongCode(attemptsLeft),
        );
      // Сессию уже стёрли — роутер уведёт на вход.
      case PinLockedOut():
        state = state.copyWith(pin: '', pinBusy: false);
    }
  }

  Future<void> _send() async {
    final repo = ref.read(refundRepositoryProvider);
    state = state.copyWith(stage: RefundStage.sending, pin: '', pinBusy: false);
    try {
      if (repo == null) throw const ApiException(ApiErrorKind.notConfigured);
      final refund = await repo.refund(
        payment,
        amountCents: state.amountCents,
        reason: state.reason,
      );
      if (!ref.mounted) return;
      // Настоящий бэк уже знает о возврате — перечитываем данные.
      // Концепт-возврат накладывается поверх них сам.
      if (repo is! ConceptRefundRepository) {
        ref
          ..invalidate(historyControllerProvider)
          ..invalidate(todaySummaryProvider)
          ..invalidate(terminalInfoProvider);
      }
      state = state.copyWith(stage: RefundStage.done, result: refund);
    } catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(stage: RefundStage.form, error: e);
    }
  }
}
