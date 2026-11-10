import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String receiptsBucket;
  final String defaultCurrencyCode;
  final String defaultCurrencySymbol;
  final String defaultTimezone;
  final bool enableRemotePush;

  const AppConfig({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    this.receiptsBucket = 'household-receipts',
    this.defaultCurrencyCode = 'TZS',
    this.defaultCurrencySymbol = 'TSh',
    this.defaultTimezone = 'Africa/Dar_es_Salaam',
    this.enableRemotePush = false,
  });

  bool get hasLiveSupabaseCredentials =>
      supabaseUrl.isNotEmpty &&
      !supabaseUrl.contains('your-project-ref') &&
      supabaseAnonKey.isNotEmpty &&
      !supabaseAnonKey.contains('your-supabase-anon-key');

  factory AppConfig.fromEnv() {
    String readEnv(String key, String fallback) {
      try {
        if (!dotenv.isInitialized) return fallback;
        return dotenv.env[key]?.trim().isNotEmpty == true
            ? dotenv.env[key]!.trim()
            : fallback;
      } catch (_) {
        return fallback;
      }
    }

    return AppConfig(
      supabaseUrl: readEnv('SUPABASE_URL', ''),
      supabaseAnonKey: readEnv('SUPABASE_ANON_KEY', ''),
      receiptsBucket: readEnv('SUPABASE_RECEIPTS_BUCKET', 'household-receipts'),
      defaultCurrencyCode: readEnv('DEFAULT_CURRENCY_CODE', 'TZS'),
      defaultCurrencySymbol: readEnv('DEFAULT_CURRENCY_SYMBOL', 'TSh'),
      defaultTimezone: readEnv('DEFAULT_TIMEZONE', 'Africa/Dar_es_Salaam'),
      enableRemotePush:
          readEnv('ENABLE_REMOTE_PUSH', 'false').toLowerCase() == 'true',
    );
  }
}

class SupportedCurrency {
  final String code;
  final String symbol;
  final String name;
  final int decimalDigits;

  const SupportedCurrency({
    required this.code,
    required this.symbol,
    required this.name,
    this.decimalDigits = 0,
  });

  static const List<SupportedCurrency> all = [
    SupportedCurrency(
      code: 'TZS',
      symbol: 'TSh',
      name: 'Tanzanian Shilling',
      decimalDigits: 0,
    ),
    SupportedCurrency(
      code: 'KES',
      symbol: 'KSh',
      name: 'Kenyan Shilling',
      decimalDigits: 0,
    ),
    SupportedCurrency(
      code: 'UGX',
      symbol: 'USh',
      name: 'Ugandan Shilling',
      decimalDigits: 0,
    ),
    SupportedCurrency(
      code: 'USD',
      symbol: '\$',
      name: 'US Dollar',
      decimalDigits: 2,
    ),
  ];

  static SupportedCurrency byCode(String code) {
    return all.firstWhere(
      (c) => c.code.toUpperCase() == code.toUpperCase(),
      orElse: () => all.first,
    );
  }
}

