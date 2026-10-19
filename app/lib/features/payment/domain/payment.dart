import 'package:flutter/foundation.dart';

enum PaymentStatus {
  success,
  cancel,
  pending,
  refunded,
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
        'refund_pending' => refundPending,
        _ => unknown,
      };
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
  });

  /// Готовое название банка отправителя (`—`, если бэк не прислал).
  final String sender;
  final int? senderBankId;

  /// Сумма в TJS.
  final double amount;
  final PaymentStatus status;

  /// Местное время платежа; `null`, если бэк прислал битую дату.
  final DateTime? createdAt;

  @override
  bool operator ==(Object other) =>
      other is Payment &&
      other.sender == sender &&
      other.senderBankId == senderBankId &&
      other.amount == amount &&
      other.status == status &&
      other.createdAt == createdAt;

  @override
  int get hashCode =>
      Object.hash(sender, senderBankId, amount, status, createdAt);
}
