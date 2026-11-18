import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../../households/data/services/firestore_ledger_sync.dart';
import '../../../households/presentation/providers/household_providers.dart';
import '../../data/services/offline_sync_coordinator.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final offlineSyncCoordinatorProvider =
    Provider<OfflineSyncCoordinator>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final repo = ref.watch(householdLedgerRepositoryProvider);
  final syncNotifier = ref.watch(syncStatusProvider.notifier);

  final coordinator = OfflineSyncCoordinator(
    db: db,
    repository: repo,
    firestoreSync: const FirestoreLedgerSyncService(),
    syncStatusNotifier: syncNotifier,
  );

  ref.onDispose(() => coordinator.dispose());
  return coordinator;
});

