import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/utils/money_format.dart';
import '../domain/refund.dart';

part 'refund_dto.freezed.dart';
part 'refund_dto.g.dart';

/// Ответ `POST /pos/payments/{id}/refund` (`docs/refund_api_spec.md`).
@freezed
abstract class RefundDto with _$RefundDto {
  const factory RefundDto({
    String? status,
    @JsonKey(name: 'refund_id') Object? refundId,
    @JsonKey(name: 'refunded_at') String? refundedAt,
    num? amount,
  }) = _RefundDto;

  const RefundDto._();

  factory RefundDto.fromJson(Map<String, dynamic> json) =>
      _$RefundDtoFromJson(json);

  /// [paymentKey], [requestedCents] и [reason] — из запроса: бэк может
  /// не повторять их в ответе.
  Refund toDomain({
    required String paymentKey,
    required int requestedCents,
    String? reason,
  }) {
    final refundStatus = switch (status?.trim().toLowerCase()) {
      'refunded' || 'done' || 'success' => RefundStatus.done,
      'pending' || 'refund_pending' || 'processing' => RefundStatus.pending,
      // «rejected» и незнакомое: деньги не ушли. Причину бэк присылает
      // ошибкой с `detail`, а не успешным ответом.
      _ => throw const ApiException(ApiErrorKind.badResponse),
    };
    final id = refundId?.toString();
    return Refund(
      paymentKey: paymentKey,
      id: (id == null || id.isEmpty) ? null : id,
      amountCents: amount == null ? requestedCents : toCents(amount!),
      createdAt:
          (refundedAt == null ? null : DateTime.tryParse(refundedAt!)) ??
          DateTime.now(),
      status: refundStatus,
      reason: reason,
    );
  }
}
