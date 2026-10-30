import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/payment.dart';

part 'payment_dto.freezed.dart';
part 'payment_dto.g.dart';

/// Платёж из `/pos/terminal` (`last_payment`) и `/pos/history` (`payments`).
@freezed
abstract class PaymentDto with _$PaymentDto {
  const factory PaymentDto({
    // Число или строка — как решит бэк.
    Object? id,
    // `internal` — клиент нашего банка, `external` — межбанк.
    String? type,
    String? sender,
    @JsonKey(name: 'sender_bank_id') int? senderBankId,
    @Default(0) num amount,
    String? status,
    @JsonKey(name: 'creation_datetime') String? creationDatetime,
    @JsonKey(name: 'refunded_amount') num? refundedAmount,
  }) = _PaymentDto;

  const PaymentDto._();

  factory PaymentDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentDtoFromJson(json);

  Payment toDomain() {
    final name = sender?.trim();
    final rawId = id?.toString().trim();
    final parsed = PaymentStatus.parse(status);
    return Payment(
      id: (rawId == null || rawId.isEmpty) ? null : rawId,
      sender: (name == null || name.isEmpty) ? '—' : name,
      type: PaymentType.parse(type),
      senderBankId: senderBankId,
      amount: amount.toDouble(),
      status: parsed,
      // Возвращён целиком, а сумму возврата бэк не прислал — значит, всю.
      refundedAmount:
          refundedAmount?.toDouble() ??
          (parsed == PaymentStatus.refunded ? amount.toDouble() : 0),
      // Дата без часового пояса — это местное время банка.
      createdAt: creationDatetime == null
          ? null
          : DateTime.tryParse(creationDatetime!),
    );
  }
}
