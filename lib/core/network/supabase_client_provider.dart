import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';

enum SyncStatus {
  synced,
  syncing,
  offlinePending,
  conflictBlocked,
}

class ConnectivitySyncState {
  final bool isOnline;
  final SyncStatus syncStatus;
  final int pendingOperationsCount;
  final DateTime? lastSyncedAt;
  final String? lastSyncMessage;

  const ConnectivitySyncState({
    this.isOnline = true,
    this.syncStatus = SyncStatus.synced,
    this.pendingOperationsCount = 0,
    this.lastSyncedAt,
    this.lastSyncMessage,
  });

  ConnectivitySyncState copyWith({
    bool? isOnline,
    SyncStatus? syncStatus,
    int? pendingOperationsCount,
    DateTime? lastSyncedAt,
    String? lastSyncMessage,
  }) {
    return ConnectivitySyncState(
      isOnline: isOnline ?? this.isOnline,
      syncStatus: syncStatus ?? this.syncStatus,
      pendingOperationsCount:
          pendingOperationsCount ?? this.pendingOperationsCount,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      lastSyncMessage: lastSyncMessage ?? this.lastSyncMessage,
    );
  }
}

class SyncStatusNotifier extends StateNotifier<ConnectivitySyncState> {
  SyncStatusNotifier()
      : super(
          ConnectivitySyncState(
            isOnline: true,
            syncStatus: SyncStatus.synced,
            pendingOperationsCount: 0,
            lastSyncedAt: DateTime.now(),
            lastSyncMessage: 'All household ledger changes synced',
          ),
        );

  void markSyncing() {
    state = state.copyWith(
      syncStatus: SyncStatus.syncing,
      lastSyncMessage: 'Syncing financial ledger with server...',
    );
  }

  void markSynced() {
    state = state.copyWith(
      isOnline: true,
      syncStatus: SyncStatus.synced,
      pendingOperationsCount: 0,
      lastSyncedAt: DateTime.now(),
      lastSyncMessage: 'All household ledger changes synced',
    );
  }

  void setOfflineMode(bool offline) {
    state = state.copyWith(
      isOnline: !offline,
      syncStatus: offline ? SyncStatus.offlinePending : SyncStatus.synced,
      lastSyncMessage: offline
          ? 'Offline mode: Financial writes require ledger version verification before sync'
          : 'Reconnected and synced',
    );
  }
}

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnv();
});

final syncStatusProvider =
    StateNotifierProvider<SyncStatusNotifier, ConnectivitySyncState>((ref) {
  return SyncStatusNotifier();
});

final supabaseClientProvider = Provider<SupabaseClient?>((ref) {
  final config = ref.watch(appConfigProvider);
  if (!config.hasLiveSupabaseCredentials) {
    return null;
  }
  try {
    return Supabase.instance.client;
  } catch (_) {
    return null;
  }
});

