import 'dart:math' as math;

import 'package:flutter/foundation.dart';

import '../../../core/utils/money_format.dart';

enum PaymentStatus {
  success,
  cancel,
  pending,
  refunded,

  /// Вернули часть суммы, остаток ещё можно вернуть.
  partiallyRefunded,
  refundPending,

  /// Статус, которого фронт не знает. Не считаем его оплатой.
  unknown;

  static PaymentStatus parse(String? raw) =>
      switch (raw?.trim().toLowerCase()) {
        'success' || 'ok' || 'paid' => success,
        'cancel' ||
        'cancelled' ||
        'canceled' ||
        'declined' ||
        'failed' ||
        'rejected' => cancel,
        'pending' || 'new' || 'processing' || 'created' => pending,
        'refunded' || 'refund' || 'reversed' => refunded,
        'partially_refunded' || 'partial_refund' => partiallyRefunded,
        'refund_pending' => refundPending,
        _ => unknown,
      };

  /// Деньги поступили (возможно, потом их вернули).
  bool get wasPaid => switch (this) {
    success || partiallyRefunded || refunded || refundPending => true,
    cancel || pending || unknown => false,
  };
}

/// Откуда пришли деньги: из другого банка или со счёта клиента ActivBank.
enum PaymentType {
  /// Межбанк: в `sender` — название банка-отправителя.
  external,

  /// Внутри банка (us-on-us): в `sender` — имя плательщика.
  internal;

  /// Без поля `type` (старый бэк) — межбанк, как было до него.
  static PaymentType parse(String? raw) =>
      raw?.trim().toLowerCase() == 'internal' ? internal : external;
}

/// Входящий платёж по QR.
@immutable
class Payment {
  const Payment({
    required this.sender,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.senderBankId,
    this.id,
    this.refundedAmount = 0,
    this.type = PaymentType.external,
  });

  /// ID платежа на бэке. Пока бэк его не отдаёт — `null`
  /// (P1 в `docs/backend_requirements.md`).
  final String? id;

  /// Банк-отправитель или, для [PaymentType.internal], имя плательщика
  /// (`—`, если бэк не прислал).
  final String sender;
  final PaymentType type;
  final int? senderBankId;

  /// Клиент ActivBank: в [sender] — имя человека, а не банк.
  bool get isInternal => type == PaymentType.internal;

  /// Сумма в TJS.
  final double amount;
  final PaymentStatus status;

  /// Местное время платежа; `null`, если бэк прислал битую дату.
  final DateTime? createdAt;

  /// Сколько уже вернули клиенту, TJS.
  final double refundedAmount;

  /// Сколько ещё можно вернуть, в дирамах.
  int get refundableCents =>
      math.max(0, toCents(amount) - toCents(refundedAmount));

  /// Оплачен и вернули не всё — можно оформить (ещё один) возврат.
  bool get canRefund =>
      (status == PaymentStatus.success ||
          status == PaymentStatus.partiallyRefunded) &&
      refundableCents > 0;

  /// По чему узнаём платёж между запросами: ID, а пока его нет —
  /// время, сумма и банк (у двух разных платежей они почти не совпадают).
  String get key =>
      id ?? '${createdAt?.toIso8601String()}|$amount|$senderBankId|$sender';

  /// Тот же платёж, у которого вернули ещё [cents] дирам.
  Payment withRefund(int cents) {
    if (cents <= 0) return this;
    final total = toCents(refundedAmount) + cents;
    return Payment(
      id: id,
      sender: sender,
      type: type,
      senderBankId: senderBankId,
      amount: amount,
      createdAt: createdAt,
      refundedAmount: total / 100,
      status: total >= toCents(amount)
          ? PaymentStatus.refunded
          : PaymentStatus.partiallyRefunded,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Payment &&
      other.id == id &&
      other.sender == sender &&
      other.type == type &&
      other.senderBankId == senderBankId &&
      other.amount == amount &&
      other.status == status &&
      other.createdAt == createdAt &&
      other.refundedAmount == refundedAmount;

  @override
  int get hashCode => Object.hash(
    id,
    sender,
    type,
    senderBankId,
    amount,
    status,
    createdAt,
    refundedAmount,
  );
}
