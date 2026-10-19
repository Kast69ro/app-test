import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/pressable_card.dart';
import '../../../../core/widgets/qr_code_view.dart';
import '../../../../core/widgets/tjqr_brand_row.dart';
import '../../../../l10n/app_localizations.dart';
import '../home_providers.dart';

/// Карточка «QR рамзи ягона» на главной. Тап — QR на весь экран.
class QrCard extends ConsumerWidget {
  const QrCard({
    super.key,
    required this.payload,
    required this.merchant,
    required this.onOpen,
  });

  /// `terminalQR`; `null` — ещё не получен.
  final String? payload;
  final String merchant;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final build = (payload == null || payload!.isEmpty)
        ? null
        : ref.watch(qrBuildProvider(payload!));
    final code = build?.code;

    return PressableCard(
      radius: AppDimens.radiusQrCard,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      onTap: code == null ? null : onOpen,
      semanticLabel: code == null ? null : l.qrOpenFullscreen,
      child: Column(
        children: [
          const FittedBox(fit: BoxFit.scaleDown, child: TjQrBrandRow()),
          const SizedBox(height: 14),
          Text(
            merchant,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.tjqrMerchant,
          ),
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 286),
            child: AspectRatio(
              aspectRatio: 1,
              child: ColoredBox(
                color: AppColors.qrBackdrop,
                child: FractionallySizedBox(
                  widthFactor: 0.764,
                  heightFactor: 0.764,
                  child: code != null
                      ? QrCodeView(code: code, semanticLabel: l.qrSemantic)
                      : const QrPlaceholder(),
                ),
              ),
            ),
          ),
          if (build?.error != null) ...[
            const SizedBox(height: 14),
            Text(
              build!.error == QrBuildError.tooLong
                  ? l.qrTooLong(payload!.length)
                  : l.qrInvalid,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: AppColors.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
