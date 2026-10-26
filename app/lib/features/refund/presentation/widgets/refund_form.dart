import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_format.dart';
import '../../../../core/utils/money_format.dart';
import '../../../../core/widgets/error_box.dart';
import '../../../../core/widgets/info_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/text_link.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../payment/domain/payment.dart';

/// Форма возврата: что за платёж, сколько вернуть, причина.
/// Состояние полей держит экран — форма только рисует.
class RefundForm extends StatelessWidget {
  const RefundForm({
    super.key,
    required this.payment,
    required this.amount,
    required this.reason,
    required this.amountError,
    required this.submitLabel,
    required this.onAll,
    required this.onChanged,
    required this.onSubmit,
    required this.onBack,
    this.error,
    this.conceptNote,
  });

  /// С учётом уже сделанных возвратов.
  final Payment payment;
  final TextEditingController amount;
  final TextEditingController reason;

  /// Подсказка под суммой («Не больше …»).
  final String? amountError;
  final String submitLabel;
  final VoidCallback onAll;
  final VoidCallback onChanged;

  /// `null` — кнопка неактивна (сумма не введена или неверна).
  final VoidCallback? onSubmit;
  final VoidCallback onBack;

  /// Ошибка прошлого запроса.
  final String? error;
  final String? conceptNote;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final p = payment;
    final at = p.createdAt;
    final subtitle = [
      p.sender,
      if (at != null) '${formatDayMonth(at)} ${formatTime(at)}',
    ].join(' · ');

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.screenPadding,
                  18,
                  AppDimens.screenPadding,
                  20,
                ),
                children: [
                  BackLink(label: l.back, onTap: onBack),
                  const SizedBox(height: 8),
                  Text(l.refundTitle, style: AppTextStyles.screenTitle),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: AppTextStyles.body.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  InfoCard(
                    children: [
                      InfoRow(l.refundPaid, formatMoney(p.amount)),
                      if (p.refundedAmount > 0)
                        InfoRow(
                          l.paymentRefunded,
                          formatMoney(p.refundedAmount),
                        ),
                      InfoRow(
                        l.paymentRefundable,
                        formatMoney(p.refundableCents / 100),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _Label(l.refundAmountLabel),
                  const SizedBox(height: 8),
                  _Field(
                    controller: amount,
                    onChanged: onChanged,
                    hasError: amountError != null,
                    style: AppTextStyles.amountRow,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,\s]')),
                    ],
                  ),
                  if (amountError != null) ...[
                    const SizedBox(height: 8),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        amountError!,
                        style: AppTextStyles.caption.copyWith(
                          color: context.colors.error,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _QuickAmount(label: l.refundAll, onTap: onAll),
                  ),
                  const SizedBox(height: 22),
                  _Label(l.refundReasonLabel),
                  const SizedBox(height: 8),
                  _Field(
                    controller: reason,
                    onChanged: onChanged,
                    hint: l.refundReasonHint,
                    maxLength: 120,
                    style: AppTextStyles.body,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 18),
                    ErrorBox(error!),
                  ],
                  if (conceptNote != null) ...[
                    const SizedBox(height: 18),
                    _ConceptNote(conceptNote!),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.screenPadding,
                8,
                AppDimens.screenPadding,
                16,
              ),
              child: PrimaryButton(label: submitLabel, onPressed: onSubmit),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: context.colors.textPrimary,
    ),
  );
}

/// Поле в стиле поля телефона на входе: белое, скругление 16, рамка 1,5.
class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.onChanged,
    required this.style,
    this.hasError = false,
    this.hint,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final VoidCallback onChanged;
  final TextStyle style;
  final bool hasError;
  final String? hint;
  final int? maxLength;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.radiusField),
      borderSide: BorderSide(color: color, width: 1.5),
    );
    return TextField(
      controller: controller,
      onChanged: (_) => onChanged(),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      maxLength: maxLength,
      cursorColor: c.accent,
      style: style.copyWith(color: c.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: style.copyWith(color: c.textTertiary),
        filled: true,
        fillColor: c.surface,
        // Счётчик символов не показываем: ограничение мягкое.
        counterText: '',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        enabledBorder: border(hasError ? c.errorBorder : c.borderList),
        focusedBorder: border(hasError ? c.error : c.accent),
      ),
    );
  }
}

/// «Вся сумма» — овальная кнопка, как чипы периода в истории.
class _QuickAmount extends StatelessWidget {
  const _QuickAmount({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    const shape = StadiumBorder();
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: c.surface,
        shape: shape.copyWith(side: BorderSide(color: c.borderList)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          customBorder: shape,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppDimens.minTap),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                widthFactor: 1,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: c.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Плашка «это демонстрация» — чтобы концепт не приняли за настоящий возврат.
class _ConceptNote extends StatelessWidget {
  const _ConceptNote(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: c.pendingBg,
        borderRadius: BorderRadius.circular(AppDimens.radiusRow),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, size: 20, color: c.pendingFg),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                height: 1.45,
                color: c.pendingFg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
