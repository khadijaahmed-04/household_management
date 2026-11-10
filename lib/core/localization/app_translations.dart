import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppLanguage {
  english,
  swahili,
}

extension AppLanguageX on AppLanguage {
  String get code => this == AppLanguage.swahili ? 'SW' : 'EN';
  String get displayName =>
      this == AppLanguage.swahili ? 'Kiswahili' : 'English';
  String get flagEmoji => this == AppLanguage.swahili ? '🇹🇿' : '🇬🇧';
}

final appLanguageProvider = StateProvider<AppLanguage>(
  (ref) => AppLanguage.english,
);

extension LocalizedRefX on WidgetRef {
  /// Returns [en] when English is active, or [sw] when Kiswahili is active.
  String tr(String en, String sw) {
    final lang = watch(appLanguageProvider);
    return lang == AppLanguage.swahili ? sw : en;
  }

  /// Translates supply, grocery, category, or transaction names so that
  /// English mode shows 100% English and Kiswahili mode shows Kiswahili.
  String trItem(String raw) {
    final lang = watch(appLanguageProvider);
    if (lang == AppLanguage.english) {
      return _toEnglish(raw);
    } else {
      return _toSwahili(raw);
    }
  }
}

String _toEnglish(String text) {
  switch (text) {
    case 'Unga (Flour)':
    case 'Unga':
      return 'Flour';
    case 'Sukari (Sugar)':
    case 'Sukari':
      return 'Sugar';
    case 'Mafuta (Cooking Oil)':
    case 'Mafuta ya Kupikia':
    case 'Mafuta':
      return 'Cooking Oil';
    case 'Viungo':
      return 'Seasonings';
    case 'Mchele (Rice)':
    case 'Mchele':
      return 'Rice';
    case 'Maziwa (Milk)':
    case 'Maziwa':
      return 'Milk';
    case 'Mayai (Eggs)':
    case 'Mayai':
      return 'Eggs';
    case 'Sabuni (Soap)':
    case 'Sabuni':
      return 'Soap';
    case 'Electricity (LUKU)':
    case 'Umeme (LUKU)':
    case 'Umeme':
      return 'Electricity';
    case 'Gesi ya Kupikia':
      return 'Cooking Gas';
    case 'Maji':
      return 'Water Supply';
    default:
      return text
          .replaceAll('Unga (Flour)', 'Flour')
          .replaceAll('Sukari (Sugar)', 'Sugar')
          .replaceAll('Mafuta (Cooking Oil)', 'Cooking Oil')
          .replaceAll('Mchele (Rice)', 'Rice')
          .replaceAll('Maziwa (Milk)', 'Milk')
          .replaceAll('Mayai (Eggs)', 'Eggs')
          .replaceAll('Sabuni (Soap)', 'Soap')
          .replaceAll('Electricity (LUKU)', 'Electricity');
  }
}

String _toSwahili(String text) {
  switch (text) {
    case 'Flour':
    case 'Unga (Flour)':
      return 'Unga';
    case 'Sugar':
    case 'Sukari (Sugar)':
      return 'Sukari';
    case 'Cooking Oil':
    case 'Mafuta (Cooking Oil)':
      return 'Mafuta ya Kupikia';
    case 'Spices':
      return 'Viungo vya Pilau';
    case 'Seasonings':
      return 'Viungo';
    case 'Rice':
    case 'Mchele (Rice)':
      return 'Mchele';
    case 'Milk':
    case 'Maziwa (Milk)':
      return 'Maziwa';
    case 'Eggs':
    case 'Mayai (Eggs)':
      return 'Mayai';
    case 'Soap':
    case 'Sabuni (Soap)':
      return 'Sabuni';
    case 'Electricity':
    case 'Electricity (LUKU)':
      return 'Umeme (LUKU)';
    case 'Cooking Gas':
      return 'Gesi ya Kupikia';
    case 'Water Supply':
    case 'Water':
      return 'Maji';
    case 'Groceries':
      return 'Mahitaji ya Jikoni';
    default:
      return text
          .replaceAll('Flour', 'Unga')
          .replaceAll('Sugar', 'Sukari')
          .replaceAll('Cooking Oil', 'Mafuta ya Kupikia')
          .replaceAll('Seasonings', 'Viungo')
          .replaceAll('Rice', 'Mchele');
  }
}
