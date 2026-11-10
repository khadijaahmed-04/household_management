import 'package:household_management/features/auth/domain/entities/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/errors/app_exceptions.dart';
//import '../domain/entities/user_profile.dart';

abstract class AuthRepository {
  Future<UserProfile?> getCurrentUser();
  Future<UserProfile> register({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
  });
  Future<UserProfile> login({
    required String email,
    required String password,
  });
  Future<void> sendPasswordResetEmail(String email);
  Future<void> updatePassword(String newPassword);
  Future<UserProfile> updateProfile(UserProfile updatedProfile);
  Future<void> logout();
}

class HybridAuthRepository implements AuthRepository {
  final SupabaseClient? _supabase;
  final _uuid = const Uuid();

  // Local session store used when Supabase credentials are not yet configured
  UserProfile? _activeUser;
  final Map<String, String> _credentialsByEmail = {
    'dida@rahisi.co.tz': 'Password123!',
  };
  final Map<String, UserProfile> _profilesByEmail = {
    'dida@rahisi.co.tz': UserProfile(
      id: 'user-admin-dida-001',
      fullName: 'Dida Mwakasege',
      email: 'dida@rahisi.co.tz',
      phoneNumber: '+255 754 100 200',
      preferredCurrency: 'TZS',
      preferredCurrencySymbol: 'TSh',
      timezone: 'Africa/Dar_es_Salaam',
      createdAt: DateTime(2026, 10, 1),
    ),
  };

  HybridAuthRepository(this._supabase) {
    _activeUser = _profilesByEmail['dida@rahisi.co.tz'];
  }

  @override
  Future<UserProfile?> getCurrentUser() async {
    if (_supabase != null) {
      final sessionUser = _supabase.auth.currentUser;
      if (sessionUser == null) return null;
      final res = await _supabase
          .from('profiles')
          .select()
          .eq('id', sessionUser.id)
          .maybeSingle();
      if (res != null) {
        return UserProfile.fromJson(res);
      }
      return UserProfile(
        id: sessionUser.id,
        fullName:
            sessionUser.userMetadata?['full_name'] as String? ?? 'Administrator',
        email: sessionUser.email ?? '',
        createdAt: DateTime.now(),
      );
    }
    return _activeUser;
  }

  @override
  Future<UserProfile> register({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (fullName.trim().length < 2) {
      throw const ValidationException('Full name must be at least 2 characters.');
    }
    if (!normalizedEmail.contains('@')) {
      throw const ValidationException('Please enter a valid email address.');
    }
    if (password.length < 8) {
      throw const ValidationException(
        'Password must be at least 8 characters long.',
      );
    }

    if (_supabase != null) {
      final authResponse = await _supabase.auth.signUp(
        email: normalizedEmail,
        password: password,
        data: {'full_name': fullName.trim()},
      );
      final user = authResponse.user;
      if (user == null) {
        throw const AppException('Registration failed. Please try again.');
      }
      final profile = UserProfile(
        id: user.id,
        fullName: fullName.trim(),
        email: normalizedEmail,
        phoneNumber: phoneNumber?.trim(),
        createdAt: DateTime.now(),
      );
      await _supabase.from('profiles').upsert(profile.toJson());
      return profile;
    }

    if (_profilesByEmail.containsKey(normalizedEmail)) {
      throw const ValidationException(
        'An account with this email address already exists.',
      );
    }

    final profile = UserProfile(
      id: _uuid.v4(),
      fullName: fullName.trim(),
      email: normalizedEmail,
      phoneNumber: phoneNumber?.trim(),
      createdAt: DateTime.now(),
    );
    _credentialsByEmail[normalizedEmail] = password;
    _profilesByEmail[normalizedEmail] = profile;
    _activeUser = profile;
    return profile;
  }

  @override
  Future<UserProfile> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty || password.isEmpty) {
      throw const ValidationException('Email and password are required.');
    }

    if (_supabase != null) {
      final response = await _supabase.auth.signInWithPassword(
        email: normalizedEmail,
        password: password,
      );
      final user = response.user;
      if (user == null) {
        throw const AppException('Invalid login credentials.');
      }
      final current = await getCurrentUser();
      if (current == null) {
        throw const AppException('Unable to load user profile.');
      }
      return current;
    }

    final storedPassword = _credentialsByEmail[normalizedEmail];
    if (_profilesByEmail.containsKey(normalizedEmail)) {
      if (storedPassword == null || storedPassword != password) {
        throw const ValidationException('Invalid email or password.');
      }
      final profile = _profilesByEmail[normalizedEmail]!;
      _activeUser = profile;
      return profile;
    }

    // Allow username login (e.g. "dida", "admin", or custom username) in local mode
    final defaultProfile = _profilesByEmail['dida@rahisi.co.tz']!;
    _activeUser = defaultProfile.copyWith(
      fullName: email.trim().contains('@')
          ? defaultProfile.fullName
          : email.trim(),
    );
    return _activeUser!;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (!normalizedEmail.contains('@')) {
      throw const ValidationException('Please enter a valid email address.');
    }
    if (_supabase != null) {
      await _supabase.auth.resetPasswordForEmail(normalizedEmail);
      return;
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    if (newPassword.length < 8) {
      throw const ValidationException(
        'New password must be at least 8 characters long.',
      );
    }
    if (_supabase != null) {
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
      return;
    }
    if (_activeUser != null) {
      _credentialsByEmail[_activeUser!.email] = newPassword;
    }
  }

  @override
  Future<UserProfile> updateProfile(UserProfile updatedProfile) async {
    if (_supabase != null) {
      await _supabase
          .from('profiles')
          .update(updatedProfile.toJson())
          .eq('id', updatedProfile.id);
    }
    _profilesByEmail[updatedProfile.email] = updatedProfile;
    _activeUser = updatedProfile;
    return updatedProfile;
  }

  @override
  Future<void> logout() async {
    if (_supabase != null) {
      await _supabase.auth.signOut();
    }
    _activeUser = null;
  }
}

