import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/date_format.dart';
import '../../../core/utils/money_format.dart';
import '../../../l10n/app_localizations.dart';
import '../../payment/presentation/payment_status_style.dart';
import '../domain/receipt.dart';

part 'receipt_pdf.g.dart';

/// Собирает чек в векторный PDF: текст выделяется, файл весит десятки КБ.
/// Состав — как у печатного чека в прототипе (стр. 619–636).
///
/// Ширина страницы фиксирована, высота — по содержимому.
/// В файл попадают только использованные глифы Montserrat.
class ReceiptPdf {
  ReceiptPdf(this._loadAsset);

  static const width = 360.0;

  /// Обычно `rootBundle.load`; в тестах — подмена.
  final Future<ByteData> Function(String path) _loadAsset;

  _Fonts? _fonts;

  Future<Uint8List> build(Receipt receipt, AppLocalizations l) async {
    final f = _fonts ??= await _Fonts.load(_loadAsset);
    final p = receipt.payment;
    final at = p.createdAt;
    final status = PaymentStatusStyle.of(p.status, l);
    String orDash(String v) => v.isEmpty ? '—' : v;

    final rows = [
      (l.paymentDate, at == null ? '—' : formatFullDate(at)),
      (l.paymentTime, at == null ? '—' : formatTime(at)),
      (l.receiptBank, p.sender),
      (l.settingsStore, orDash(receipt.storeName)),
      (l.settingsTerminal, orDash(receipt.terminalName)),
      (l.settingsTerminalId, orDash(receipt.terminalId)),
    ];

    final doc = pw.Document(title: l.receiptTitle, creator: l.appTitle);
    doc.addPage(
      pw.Page(
        // Без полей: фон чека заливает всю страницу.
        pageFormat: const PdfPageFormat(width, double.infinity),
        theme: pw.ThemeData.withFont(base: f.regular, bold: f.bold),
        build: (_) => pw.Container(
          color: _c(AppColors.background),
          padding: const pw.EdgeInsets.all(16),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Text(
                l.appTitle,
                style: pw.TextStyle(
                  font: f.bold,
                  fontSize: 16,
                  letterSpacing: -0.16,
                  color: _c(AppColors.textPrimary),
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(l.receiptTitle, style: _caption),
              pw.SizedBox(height: 16),
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: _card,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(l.receiptAmount, style: _caption),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      formatMoney(p.amount),
                      style: pw.TextStyle(
                        font: f.semiBold,
                        fontSize: 32,
                        letterSpacing: -0.64,
                        color: _c(AppColors.textPrimary),
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: pw.BoxDecoration(
                        color: _c(status.bg),
                        borderRadius: pw.BorderRadius.circular(
                          AppDimens.radiusChip,
                        ),
                      ),
                      child: pw.Text(
                        status.label,
                        style: pw.TextStyle(fontSize: 13, color: _c(status.fg)),
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: _card,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    for (final (i, (label, value)) in rows.indexed) ...[
                      if (i > 0) pw.SizedBox(height: 14),
                      _row(label, value, f),
                    ],
                  ],
                ),
              ),
              pw.SizedBox(height: 14),
              pw.Text(
                l.receiptFooter,
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 12,
                  color: _c(AppColors.textTertiary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return doc.save();
  }

  /// Подпись — не шире половины строки, значение — справа.
  pw.Widget _row(String label, String value, _Fonts f) => pw.LayoutBuilder(
    builder: (_, constraints) => pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.ConstrainedBox(
          constraints: pw.BoxConstraints(maxWidth: constraints!.maxWidth / 2),
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 14,
              color: _c(AppColors.textSecondary),
            ),
          ),
        ),
        pw.SizedBox(width: 14),
        pw.Expanded(
          child: pw.Text(
            value,
            textAlign: pw.TextAlign.right,
            style: pw.TextStyle(
              font: f.medium,
              fontSize: 14,
              color: _c(AppColors.textPrimary),
            ),
          ),
        ),
      ],
    ),
  );

  static final _caption = pw.TextStyle(
    fontSize: 13,
    color: _c(AppColors.textSecondary),
  );

  static final _card = pw.BoxDecoration(
    color: _c(AppColors.surface),
    border: pw.Border.all(color: _c(AppColors.borderList)),
    borderRadius: pw.BorderRadius.circular(AppDimens.radiusRow),
  );

  /// Цвета берём из темы приложения, чтобы не дублировать их здесь.
  static PdfColor _c(Color color) => PdfColor.fromInt(color.toARGB32());
}

/// Montserrat из ассетов приложения — тот же, что в интерфейсе.
class _Fonts {
  _Fonts(this.regular, this.medium, this.semiBold, this.bold);

  final pw.Font regular;
  final pw.Font medium;
  final pw.Font semiBold;
  final pw.Font bold;

  static Future<_Fonts> load(
    Future<ByteData> Function(String) loadAsset,
  ) async {
    Future<pw.Font> font(String weight) async => pw.Font.ttf(
      await loadAsset('assets/fonts/${AppFonts.brand}-$weight.ttf'),
    );
    return _Fonts(
      await font('Regular'),
      await font('Medium'),
      await font('SemiBold'),
      await font('Bold'),
    );
  }
}

/// keepAlive: шрифты разбираются один раз за сессию, а не на каждый чек.
@Riverpod(keepAlive: true)
ReceiptPdf receiptPdf(Ref ref) => ReceiptPdf(rootBundle.load);
