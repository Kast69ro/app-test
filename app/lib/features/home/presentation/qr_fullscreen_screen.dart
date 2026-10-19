import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/qr_code_view.dart';
import '../../../core/widgets/tjqr_brand_row.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/presentation/session_controller.dart';
import 'home_providers.dart';

/// QR на весь экран для сканирования. Прототип: стр. 122–133.
/// Яркость на максимум и экран не гаснет, пока QR открыт.
class QrFullscreenScreen extends ConsumerStatefulWidget {
  const QrFullscreenScreen({super.key});

  @override
  ConsumerState<QrFullscreenScreen> createState() => _QrFullscreenState();
}

class _QrFullscreenState extends ConsumerState<QrFullscreenScreen> {
  @override
  void initState() {
    super.initState();
    // Ошибки плагинов (например, в браузере) не мешают показать QR.
    ScreenBrightness.instance
        .setApplicationScreenBrightness(1)
        .catchError((Object _) {});
    WakelockPlus.enable().catchError((Object _) {});
  }

  @override
  void dispose() {
    ScreenBrightness.instance.resetApplicationScreenBrightness().catchError(
      (Object _) {},
    );
    WakelockPlus.disable().catchError((Object _) {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final session = ref.watch(sessionControllerProvider).value?.session;
    final payload = session?.terminalQR ?? '';
    final code = payload.isEmpty
        ? null
        : ref.watch(qrBuildProvider(payload)).code;
    final merchant = (session?.storeName.isNotEmpty ?? false)
        ? session!.storeName
        : '—';

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Semantics(
        button: true,
        label: l.qrTapToClose,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).maybePop(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: LayoutBuilder(
                builder: (context, c) {
                  final size = MediaQuery.sizeOf(context);
                  // min(92vw, 78vh), но не больше, чем остаётся под подписи.
                  final side = math.min(
                    math.min(size.width * 0.92, size.height * 0.78),
                    math.min(c.maxWidth, c.maxHeight - 160),
                  );
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: TjQrBrandRow(),
                      ),
                      const SizedBox(height: 20),
                      SizedBox.square(
                        dimension: math.max(side, 0),
                        child: code == null
                            ? const QrPlaceholder()
                            : QrCodeView(
                                code: code,
                                semanticLabel: l.qrSemantic,
                              ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        merchant,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.tjqrMerchant.copyWith(
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l.qrTapToClose,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
