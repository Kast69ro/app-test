// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentDto _$PaymentDtoFromJson(Map<String, dynamic> json) => _PaymentDto(
  id: json['id'],
  sender: json['sender'] as String?,
  senderBankId: (json['sender_bank_id'] as num?)?.toInt(),
  amount: json['amount'] as num? ?? 0,
  status: json['status'] as String?,
  creationDatetime: json['creation_datetime'] as String?,
  refundedAmount: json['refunded_amount'] as num?,
);

Map<String, dynamic> _$PaymentDtoToJson(_PaymentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender': instance.sender,
      'sender_bank_id': instance.senderBankId,
      'amount': instance.amount,
      'status': instance.status,
      'creation_datetime': instance.creationDatetime,
      'refunded_amount': instance.refundedAmount,
    };
