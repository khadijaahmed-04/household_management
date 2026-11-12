import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../households/presentation/providers/household_providers.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/entities/user_profile.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

class AuthController extends StateNotifier<AsyncValue<UserProfile?>> {
  final AuthRepository _repository;
  final Ref _ref;

  AuthController(this._repository, this._ref)
      : super(const AsyncValue.loading()) {
    checkSession();
  }

  Future<void> checkSession() async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        await _syncHouseholds(user.id);
      }
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.login(email: email, password: password);
      await _syncHouseholds(user.id);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.register(
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );
      await _syncHouseholds(user.id);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final user = await _repository.signInWithGoogle();
      await _syncHouseholds(user.id);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateProfile(UserProfile updated) async {
    final saved = await _repository.updateProfile(updated);
    state = AsyncValue.data(saved);
  }

  Future<void> logout() async {
    await _repository.logout();
    try {
      _ref.read(householdLedgerRepositoryProvider).clearSessionData();
      _ref.read(selectedHouseholdIdProvider.notifier).state = null;
      _ref.read(ledgerRevisionProvider.notifier).state++;
    } catch (_) {}
    state = const AsyncValue.data(null);
  }

  Future<void> _syncHouseholds(String userId) async {
    try {
      await _ref.read(householdLedgerRepositoryProvider).syncForUser(userId);
      _ref.read(ledgerRevisionProvider.notifier).state++;
    } catch (_) {
      // Offline cache continues transparently if cloud sync fails.
    }
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<UserProfile?>>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthController(repo, ref);
});
