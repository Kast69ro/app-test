// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refund_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RefundDto _$RefundDtoFromJson(Map<String, dynamic> json) => _RefundDto(
  status: json['status'] as String?,
  refundId: json['refund_id'],
  refundedAt: json['refunded_at'] as String?,
  amount: json['amount'] as num?,
);

Map<String, dynamic> _$RefundDtoToJson(_RefundDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'refund_id': instance.refundId,
      'refunded_at': instance.refundedAt,
      'amount': instance.amount,
    };
