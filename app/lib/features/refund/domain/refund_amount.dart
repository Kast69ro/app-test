/// Почему сумму возврата нельзя отправить.
enum RefundAmountError {
  /// Не число или больше двух знаков после запятой.
  invalid,

  /// Ноль.
  zero,

  /// Больше, чем осталось вернуть.
  tooMuch,
}

/// Проверка суммы возврата. [cents] — результат `parseMoney` (`null` —
/// не разобрали). `null` в ответе — сумма в порядке.
RefundAmountError? checkRefundAmount(int? cents, int refundableCents) {
  if (cents == null) return RefundAmountError.invalid;
  if (cents <= 0) return RefundAmountError.zero;
  if (cents > refundableCents) return RefundAmountError.tooMuch;
  return null;
}
