import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  static final DateFormat _ddMmmYyyy = DateFormat('dd MMM yyyy');
  static final DateFormat _ddMmmYyyyTime = DateFormat('dd MMM yyyy, HH:mm');
  static final DateFormat _monthYear = DateFormat('MMMM yyyy');

  /// Formats monetary values in Tanzanian Shillings (e.g. `TSh 100,000`)
  /// or any other configured household currency symbol.
  static String formatCurrency(
    num amount, {
    String symbol = 'TSh',
    int decimalDigits = 0,
    bool showSign = false,
  }) {
    final isNegative = amount < 0;
    final absValue = amount.abs();
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '',
      decimalDigits: decimalDigits,
    );
    final formattedNumber = formatter.format(absValue).trim();
    if (showSign) {
      final prefix = isNegative ? '-' : '+';
      return '$prefix$symbol $formattedNumber';
    }
    return isNegative
        ? '-$symbol $formattedNumber'
        : '$symbol $formattedNumber';
  }

  /// Formats a DateTime using the required Tanzanian standard `DD MMM YYYY` (e.g. `05 Nov 2026`).
  static String formatDate(DateTime date) {
    return _ddMmmYyyy.format(date);
  }

  /// Formats a DateTime with time (`05 Nov 2026, 14:30`).
  static String formatDateTime(DateTime dateTime) {
    return _ddMmmYyyyTime.format(dateTime);
  }

  /// Formats a month header (`November 2026`).
  static String formatMonthYear(DateTime date) {
    return _monthYear.format(date);
  }

  /// Converts a UTC DateTime into `Africa/Dar_es_Salaam` (UTC+3).
  static DateTime toDarEsSalaamTime(DateTime input) {
    final utc = input.toUtc();
    return utc.add(const Duration(hours: 3));
  }

  /// Parses monetary amounts entered by users. Robustly handles:
  /// - Commas: `15,000` -> `15000.0`
  /// - Spaces: `15 000` -> `15000.0`
  /// - Compact 'k' / 'K': `10k`, `10K`, `15k` -> `10000.0`, `15000.0`
  /// - Compact 'm' / 'M': `1m`, `1.5m` -> `1000000.0`, `1500000.0`
  /// - Plain numbers: `10000` -> `10000.0`
  static double? tryParseAmount(String? input) {
    if (input == null) return null;
    final cleaned = input
        .replaceAll(',', '')
        .replaceAll(' ', '')
        .trim()
        .toLowerCase();
    if (cleaned.isEmpty) return null;
    if (cleaned.endsWith('k')) {
      final value =
          double.tryParse(cleaned.substring(0, cleaned.length - 1).trim());
      return value != null ? value * 1000 : null;
    }
    if (cleaned.endsWith('m')) {
      final value =
          double.tryParse(cleaned.substring(0, cleaned.length - 1).trim());
      return value != null ? value * 1000000 : null;
    }
    return double.tryParse(cleaned);
  }
}

