/// Сумма в TJS для UI: `12 345,60`. Валюту не пишем (см. CLAUDE.md).
///
/// Тысячи разделяются неразрывным пробелом, чтобы сумма не переносилась.
/// Округляем сразу до дирамов: иначе 1.999 превращается в «1,100».
String formatMoney(num value) {
  final cents = (value * 100).round();
  final sign = cents < 0 ? '−' : '';
  final abs = cents.abs();
  final whole = (abs ~/ 100).toString();
  final fraction = (abs % 100).toString().padLeft(2, '0');

  final grouped = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) grouped.write(' ');
    grouped.write(whole[i]);
  }
  return '$sign$grouped,$fraction';
}

/// Сумма в дирамах (1 TJS = 100 дирам). Считаем в целых, чтобы не копить
/// ошибку double при сложении и вычитании.
int toCents(num value) => (value * 100).round();

/// Сумма для поля ввода: `1234,50` — без пробелов, чтобы её было удобно
/// править.
String formatMoneyInput(int cents) =>
    '${cents ~/ 100},${(cents % 100).toString().padLeft(2, '0')}';

/// Сумма, которую ввёл человек: `150`, `150,5`, `1 234.50`.
/// Возвращает дирамы или `null`, если это не сумма (буквы, 3 знака после
/// запятой, две запятые).
int? parseMoney(String text) {
  final s = text.replaceAll(RegExp(r'[\s ]'), '').replaceAll(',', '.');
  final m = RegExp(r'^(\d{1,9})(?:\.(\d{0,2}))?$').firstMatch(s);
  if (m == null) return null;
  final whole = int.parse(m.group(1)!);
  final fraction = (m.group(2) ?? '').padRight(2, '0');
  return whole * 100 + int.parse(fraction);
}
