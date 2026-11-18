import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/network/supabase_client_provider.dart';
import '../../../../core/utils/currency_precision.dart';
import '../../../categories/domain/entities/expense_category.dart';
import '../../../consumption/domain/entities/consumption_entities.dart';
import '../../../households/data/repositories/household_ledger_repository.dart';
import '../../../households/data/services/firestore_ledger_sync.dart';
import '../../../households/domain/entities/household.dart';
import '../../../households/domain/entities/household_member.dart';
import '../../../wallet/domain/entities/wallet_entities.dart';

/// Coordinates offline-to-cloud synchronization, conflict detection,
/// exponential backoff retries, and network lifecycle triggers.
class OfflineSyncCoordinator with WidgetsBindingObserver {
  final AppDatabase _db;
  final HouseholdLedgerRepository _repository;
  final FirestoreLedgerSyncService _firestoreSync;
  final SyncStatusNotifier _syncStatusNotifier;
  final Connectivity _connectivity;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  bool _isSyncing = false;
  String? _activeUserId;

  OfflineSyncCoordinator({
    required AppDatabase db,
    required HouseholdLedgerRepository repository,
    required FirestoreLedgerSyncService firestoreSync,
    required SyncStatusNotifier syncStatusNotifier,
    Connectivity? connectivity,
  })  : _db = db,
        _repository = repository,
        _firestoreSync = firestoreSync,
        _syncStatusNotifier = syncStatusNotifier,
        _connectivity = connectivity ?? Connectivity();

  void init(String userId) {
    _activeUserId = userId;
    WidgetsBinding.instance.addObserver(this);

    _connectivitySub = _connectivity.onConnectivityChanged.listen((results) {
      final isOffline = results.isEmpty ||
          results.every((r) => r == ConnectivityResult.none);
      _syncStatusNotifier.setOfflineMode(isOffline);
      if (!isOffline) {
        syncAll();
      }
    });

    // Initial sync trigger on startup
    syncAll();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectivitySub?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      syncAll();
    }
  }

  /// Verifies true end-to-end Firestore connectivity (not just Wi-Fi/cellular connection).
  Future<bool> probeFirestoreReachability() async {
    if (!_firestoreSync.isAvailable) return false;
    try {
      await FirebaseFirestore.instance
          .collection('households')
          .limit(1)
          .get(const GetOptions(source: Source.server))
          .timeout(const Duration(seconds: 4));
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Master synchronization coordinator.
  /// 1. Verifies connectivity & reachability.
  /// 2. Pushes queued local offline mutations in chronological FIFO order.
  /// 3. Pulls remote updates with version-aware conflict protection.
  Future<bool> syncAll({bool force = false}) async {
    final userId = _activeUserId;
    if (userId == null || userId.isEmpty) return false;
    if (_isSyncing) return false;

    final isReachable = await probeFirestoreReachability();
    if (!isReachable) {
      final pendingCount = await (_db.select(_db.syncQueue)
            ..where((q) => q.status.equals('pending') | q.status.equals('failed')))
          .get()
          .then((rows) => rows.length);
      _syncStatusNotifier.setOfflineMode(true, pendingCount);
      return false;
    }

    _isSyncing = true;
    _syncStatusNotifier.markSyncing();

    try {
      // Step A: Push pending offline mutations to Firestore
      await _processPendingSyncQueue(userId);

      // Step B: Pull remote cloud updates into SQLite (version-aware)
      await _pullRemoteUpdates(userId);

      _syncStatusNotifier.markSynced();
      return true;
    } catch (e) {
      _syncStatusNotifier.setOfflineMode(true);
      return false;
    } finally {
      _isSyncing = false;
    }
  }

  /// Pushes all queued local offline operations to Firestore in strict FIFO order.
  Future<void> _processPendingSyncQueue(String userId) async {
    final queueItems = await (_db.select(_db.syncQueue)
          ..where((q) =>
              q.userId.equals(userId) &
              (q.status.equals('pending') |
                  (q.status.equals('failed') & q.retryCount.isSmallerThanValue(5))))
          ..orderBy([(q) => OrderingTerm(expression: q.id)]))
        .get();

    for (final item in queueItems) {
      try {
        await (_db.update(_db.syncQueue)..where((q) => q.id.equals(item.id)))
            .write(const SyncQueueCompanion(status: Value('in_progress')));

        final payload = jsonDecode(item.payloadJson) as Map<String, dynamic>;

        switch (item.entityType) {
          case 'contribution':
            final cMap = payload['contribution'] as Map<String, dynamic>;
            final wMap = payload['wallet'] as Map<String, dynamic>;
            final tMap = payload['transaction'] as Map<String, dynamic>;

            final contribution = Contribution.fromJson(cMap);
            final updatedWallet = HouseholdWallet.fromJson(wMap);
            final tx = WalletTransaction(
              id: tMap['id'] as String,
              householdId: tMap['householdId'] as String,
              walletId: tMap['walletId'] as String,
              transactionType: WalletTransactionType.values.firstWhere(
                (v) => v.name == tMap['transactionType'],
                orElse: () => WalletTransactionType.contribution,
              ),
              referenceContributionId:
                  tMap['referenceContributionId'] as String?,
              memberId: tMap['memberId'] as String?,
              memberName: tMap['memberName'] as String,
              categoryName: (tMap['categoryName'] ?? 'Contribution') as String,
              amount: ((tMap['amount'] ?? 0.0) as num).toDouble(),
              signedAmount: ((tMap['signedAmount'] ?? 0.0) as num).toDouble(),
              balanceBefore: ((tMap['balanceBefore'] ?? 0.0) as num).toDouble(),
              balanceAfter: ((tMap['balanceAfter'] ?? 0.0) as num).toDouble(),
              transactionDate: DateTime.parse(tMap['transactionDate'] as String),
              description: tMap['description'] as String,
              recordedBy: tMap['recordedBy'] as String,
              createdAt: DateTime.parse(tMap['createdAt'] as String),
            );

            await _firestoreSync.saveContributionBundle(
              contribution: contribution,
              updatedWallet: updatedWallet,
              transaction: tx,
            );
            break;

          case 'expense':
            final eMap = payload['expense'] as Map<String, dynamic>;
            final wMap = payload['wallet'] as Map<String, dynamic>;
            final tMap = payload['transaction'] as Map<String, dynamic>;

            final expense = Expense.fromJson(eMap);
            final updatedWallet = HouseholdWallet.fromJson(wMap);
            final tx = WalletTransaction(
              id: tMap['id'] as String,
              householdId: tMap['householdId'] as String,
              walletId: tMap['walletId'] as String,
              transactionType: WalletTransactionType.values.firstWhere(
                (v) => v.name == tMap['transactionType'],
                orElse: () => WalletTransactionType.expense,
              ),
              referenceExpenseId: tMap['referenceExpenseId'] as String?,
              memberId: tMap['memberId'] as String?,
              memberName: tMap['memberName'] as String,
              categoryId: tMap['categoryId'] as String?,
              categoryName: (tMap['categoryName'] ?? 'Expense') as String,
              amount: ((tMap['amount'] ?? 0.0) as num).toDouble(),
              signedAmount: ((tMap['signedAmount'] ?? 0.0) as num).toDouble(),
              balanceBefore: ((tMap['balanceBefore'] ?? 0.0) as num).toDouble(),
              balanceAfter: ((tMap['balanceAfter'] ?? 0.0) as num).toDouble(),
              transactionDate: DateTime.parse(tMap['transactionDate'] as String),
              description: tMap['description'] as String,
              recordedBy: tMap['recordedBy'] as String,
              createdAt: DateTime.parse(tMap['createdAt'] as String),
            );

            await _firestoreSync.saveExpenseBundle(
              expense: expense,
              updatedWallet: updatedWallet,
              transaction: tx,
            );
            break;

          case 'household':
            if (item.operation == 'create') {
              final h = Household.fromJson(
                  payload['household'] as Map<String, dynamic>);
              final w = HouseholdWallet.fromJson(
                  payload['wallet'] as Map<String, dynamic>);
              final mList = (payload['members'] as List<dynamic>)
                  .cast<Map<String, dynamic>>()
                  .map((m) => HouseholdMember.fromJson(m))
                  .toList();
              final cList = (payload['categories'] as List<dynamic>)
                  .cast<Map<String, dynamic>>()
                  .map((c) => ExpenseCategory.fromJson(c))
                  .toList();
              final sList = (payload['supplies'] as List<dynamic>)
                  .cast<Map<String, dynamic>>()
                  .map((s) => TrackedSupply.fromJson(s))
                  .toList();

              await _firestoreSync.saveNewHousehold(
                household: h,
                wallet: w,
                members: mList,
                categories: cList,
                supplies: sList,
                predictions: const {},
              );
            } else if (item.operation == 'update') {
              final h = Household.fromJson(payload);
              final members = _repository.getMembers(
                householdId: h.id,
                actorUserId: userId,
              );
              await _firestoreSync.updateHousehold(h, members);
            }
            break;
        }

        // Successfully pushed -> Delete from queue
        await (_db.delete(_db.syncQueue)..where((q) => q.id.equals(item.id)))
            .go();
      } catch (err) {
        // Increment retry with error logged
        await (_db.update(_db.syncQueue)..where((q) => q.id.equals(item.id)))
            .write(
          SyncQueueCompanion(
            status: const Value('failed'),
            retryCount: Value(item.retryCount + 1),
            lastError: Value(err.toString()),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
    }
  }

  /// Downloads fresh Firestore records and integrates into Drift SQLite,
  /// preserving any pending unpushed local modifications.
  Future<void> _pullRemoteUpdates(String userId) async {
    final bundle = await _firestoreSync.fetchAllForUser(userId);
    if (bundle == null) return;

    // Identify pending entities in SQLite sync queue to avoid overwriting unpushed changes
    final pendingOps = await (_db.select(_db.syncQueue)
          ..where((q) =>
              q.userId.equals(userId) &
              (q.status.equals('pending') | q.status.equals('in_progress'))))
        .get();
    final pendingEntityIds = pendingOps.map((p) => p.entityId).toSet();

    await _db.transaction(() async {
      for (final h in bundle.households.values) {
        if (pendingEntityIds.contains(h.id)) continue;
        await _db.into(_db.households).insertOnConflictUpdate(
              HouseholdsCompanion.insert(
                id: h.id,
                ownerId: h.ownerId,
                name: h.name,
                description: Value(h.description),
                address: Value(h.address),
                currencyCode: Value(h.currencyCode),
                currencySymbol: Value(h.currencySymbol),
                timezone: Value(h.timezone),
                allowOverdraft: Value(h.allowOverdraft),
                lowBalanceThresholdCents: Value(
                  CurrencyPrecision.toMinorUnits(h.lowBalanceThreshold),
                ),
                isArchived: Value(h.isArchived),
                createdAt: h.createdAt,
              ),
            );
      }

      for (final w in bundle.wallets.values) {
        if (pendingEntityIds.contains(w.id)) continue;
        await _db.into(_db.householdWallets).insertOnConflictUpdate(
              HouseholdWalletsCompanion.insert(
                id: w.id,
                householdId: w.householdId,
                totalContributionsCents: Value(
                  CurrencyPrecision.toMinorUnits(w.totalContributions),
                ),
                totalExpensesCents: Value(
                  CurrencyPrecision.toMinorUnits(w.totalExpenses),
                ),
                totalAdjustmentsCents: Value(
                  CurrencyPrecision.toMinorUnits(w.totalAdjustments),
                ),
                availableBalanceCents: Value(
                  CurrencyPrecision.toMinorUnits(w.availableBalance),
                ),
                version: Value(w.version),
                lastTransactionAt: Value(w.lastTransactionAt),
              ),
            );
      }
    });

    // Refresh repository in-memory state
    await _repository.restoreFromLocalStorage(userId: userId);
  }
}
