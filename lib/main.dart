import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/app_config.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/nyumba_wave_background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // AppConfig falls back to safe local defaults when .env is not present.
  }

  final config = AppConfig.fromEnv();
  if (config.hasLiveSupabaseCredentials) {
    try {
      await Supabase.initialize(
        url: config.supabaseUrl,
        anonKey: config.supabaseAnonKey,
      );
    } catch (_) {
      // Continues in offline-resilient hybrid mode if initialization fails.
    }
  }

  runApp(const ProviderScope(child: NyumbaSmartApp()));
}

class NyumbaSmartApp extends ConsumerWidget {
  const NyumbaSmartApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    return MaterialApp.router(
      title: 'NyumbaSmart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) => NyumbaAppWaveBackground(
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
