import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/app_exceptions.dart';
import '../../domain/entities/user_profile.dart';

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

  Future<UserProfile> signInWithGoogle();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> updatePassword(String newPassword);

  Future<UserProfile> updateProfile(UserProfile updatedProfile);

  Future<void> logout();
}

class FirebaseAuthRepository implements AuthRepository {
  static const String _googleWebClientId =
      '674739876070-9gafqbb8e6uu5n0192u4fs0hpis0jbqu.apps.googleusercontent.com';

  static Future<void>? _googleInitFuture;

  final FirebaseAuth? _authOverride;
  final FirebaseFirestore? _firestoreOverride;
  final _uuid = const Uuid();

  // In-memory fallback used only when Firebase is unavailable (e.g. unit tests).
  UserProfile? _fallbackActiveUser;
  final Map<String, String> _fallbackCredentialsByEmail = {};
  final Map<String, UserProfile> _fallbackProfilesByEmail = {};

  FirebaseAuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _authOverride = auth,
        _firestoreOverride = firestore;

  bool get _isFirebaseReady {
    if (_authOverride != null && _firestoreOverride != null) return true;
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  FirebaseAuth? get _auth {
    if (_authOverride != null) return _authOverride;
    if (!_isFirebaseReady) return null;
    return FirebaseAuth.instance;
  }

  FirebaseFirestore? get _firestore {
    if (_firestoreOverride != null) return _firestoreOverride;
    if (!_isFirebaseReady) return null;
    return FirebaseFirestore.instance;
  }

  Future<void> _ensureGoogleInitialized() {
    _googleInitFuture ??= GoogleSignIn.instance.initialize(
      serverClientId: _googleWebClientId,
    );
    return _googleInitFuture!;
  }

  @override
  Future<UserProfile?> getCurrentUser() async {
    final auth = _auth;
    final firestore = _firestore;
    if (auth == null || firestore == null) {
      return _fallbackActiveUser;
    }

    final fbUser = auth.currentUser;
    if (fbUser == null) return null;

    return _loadOrCreateProfileFromFirebaseUser(fbUser, firestore);
  }

  @override
  Future<UserProfile> register({
    required String fullName,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    final trimmedName = fullName.trim();
    final normalizedEmail = email.trim().toLowerCase();
    final trimmedPhone =
        phoneNumber != null && phoneNumber.trim().isNotEmpty
            ? phoneNumber.trim()
            : null;

    if (trimmedName.length < 2) {
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

    final auth = _auth;
    final firestore = _firestore;
    if (auth == null || firestore == null) {
      if (_fallbackProfilesByEmail.containsKey(normalizedEmail)) {
        throw const ValidationException(
          'An account with this email address already exists.',
        );
      }
      final profile = UserProfile(
        id: _uuid.v4(),
        fullName: trimmedName,
        email: normalizedEmail,
        phoneNumber: trimmedPhone,
        createdAt: DateTime.now(),
      );
      _fallbackCredentialsByEmail[normalizedEmail] = password;
      _fallbackProfilesByEmail[normalizedEmail] = profile;
      _fallbackActiveUser = profile;
      return profile;
    }

    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      final fbUser = credential.user;
      if (fbUser == null) {
        throw const AppException('Registration failed. Please try again.');
      }
      await fbUser.updateDisplayName(trimmedName);

      final now = DateTime.now();
      final profile = UserProfile(
        id: fbUser.uid,
        fullName: trimmedName,
        email: fbUser.email ?? normalizedEmail,
        phoneNumber: trimmedPhone,
        createdAt: now,
      );

      await firestore.collection('users').doc(fbUser.uid).set(
            _toFirestoreMap(
              profile,
              photoUrl: fbUser.photoURL,
              isCreate: true,
            ),
          );
      return profile;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
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
    if (!normalizedEmail.contains('@')) {
      throw const ValidationException('Please enter a valid email address.');
    }

    final auth = _auth;
    final firestore = _firestore;
    if (auth == null || firestore == null) {
      final storedPassword = _fallbackCredentialsByEmail[normalizedEmail];
      final existing = _fallbackProfilesByEmail[normalizedEmail];
      if (existing == null || storedPassword == null || storedPassword != password) {
        throw const ValidationException('Invalid email or password.');
      }
      _fallbackActiveUser = existing;
      return existing;
    }

    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );
      final fbUser = credential.user;
      if (fbUser == null) {
        throw const AppException('Invalid login credentials.');
      }
      return _loadOrCreateProfileFromFirebaseUser(fbUser, firestore);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
  }

  @override
  Future<UserProfile> signInWithGoogle() async {
    final auth = _auth;
    final firestore = _firestore;
    if (auth == null || firestore == null) {
      throw const AppException(
        'Google Sign-In requires Firebase configuration on this device.',
      );
    }

    try {
      await _ensureGoogleInitialized();
      final googleUser = await GoogleSignIn.instance.authenticate();
      final idToken = googleUser.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        throw const AppException(
          'Unable to verify Google account token. Please try again.',
        );
      }

      final oauthCredential = GoogleAuthProvider.credential(idToken: idToken);
      final userCredential = await auth.signInWithCredential(oauthCredential);
      final fbUser = userCredential.user;
      if (fbUser == null) {
        throw const AppException('Google sign-in failed. Please try again.');
      }

      return _loadOrCreateProfileFromFirebaseUser(
        fbUser,
        firestore,
        fallbackName: googleUser.displayName,
        fallbackEmail: googleUser.email,
        fallbackPhotoUrl: googleUser.photoUrl,
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted) {
        throw const ValidationException('Google sign-in was cancelled.');
      }
      throw AppException(
        e.description ?? 'Google sign-in failed (${e.code.name}).',
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (!normalizedEmail.contains('@')) {
      throw const ValidationException('Please enter a valid email address.');
    }

    final auth = _auth;
    if (auth == null) return;

    try {
      await auth.sendPasswordResetEmail(email: normalizedEmail);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    if (newPassword.length < 8) {
      throw const ValidationException(
        'New password must be at least 8 characters long.',
      );
    }

    final auth = _auth;
    if (auth == null) {
      if (_fallbackActiveUser != null) {
        _fallbackCredentialsByEmail[_fallbackActiveUser!.email] = newPassword;
      }
      return;
    }

    final fbUser = auth.currentUser;
    if (fbUser == null) {
      throw const AppException(
        'Please sign in again to change your password.',
        code: 'requires-recent-login',
      );
    }

    try {
      await fbUser.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
  }

  @override
  Future<UserProfile> updateProfile(UserProfile updatedProfile) async {
    final auth = _auth;
    final firestore = _firestore;
    if (auth == null || firestore == null) {
      _fallbackProfilesByEmail[updatedProfile.email] = updatedProfile;
      _fallbackActiveUser = updatedProfile;
      return updatedProfile;
    }

    final fbUser = auth.currentUser;
    if (fbUser == null) {
      throw const AppException(
        'No authenticated user session.',
        code: 'unauthenticated',
      );
    }

    if (updatedProfile.fullName.trim().isNotEmpty &&
        fbUser.displayName != updatedProfile.fullName.trim()) {
      await fbUser.updateDisplayName(updatedProfile.fullName.trim());
    }

    final docRef = firestore.collection('users').doc(updatedProfile.id);
    final existing = await docRef.get();
    final payload = _toFirestoreMap(
      updatedProfile,
      photoUrl: fbUser.photoURL,
      isCreate: !existing.exists,
    );
    if (existing.exists) {
      await docRef.update(payload);
    } else {
      await docRef.set(payload);
    }

    return updatedProfile;
  }

  @override
  Future<void> logout() async {
    final auth = _auth;
    if (auth != null) {
      await auth.signOut();
      if (!kIsWeb) {
        try {
          await _ensureGoogleInitialized();
          await GoogleSignIn.instance.signOut();
        } catch (_) {
          // Ignore if no cached Google session exists.
        }
      }
    }
    _fallbackActiveUser = null;
  }

  Future<UserProfile> _loadOrCreateProfileFromFirebaseUser(
    User fbUser,
    FirebaseFirestore firestore, {
    String? fallbackName,
    String? fallbackEmail,
    String? fallbackPhotoUrl,
  }) async {
    final docRef = firestore.collection('users').doc(fbUser.uid);
    DocumentSnapshot<Map<String, dynamic>>? snap;
    try {
      snap = await docRef.get();
    } catch (_) {
      // Fall back to cached snapshot if offline.
      try {
        snap = await docRef.get(const GetOptions(source: Source.cache));
      } catch (_) {}
    }

    if (snap != null && snap.exists && snap.data() != null) {
      return _fromFirestoreMap(fbUser.uid, snap.data()!, fbUser);
    }

    final resolvedEmail =
        (fbUser.email ?? fallbackEmail ?? '').trim().toLowerCase();
    final rawName = (fbUser.displayName ?? fallbackName ?? '').trim();
    final resolvedName = rawName.isNotEmpty
        ? rawName
        : (resolvedEmail.contains('@')
            ? resolvedEmail.split('@').first
            : 'Household Member');

    final profile = UserProfile(
      id: fbUser.uid,
      fullName: resolvedName,
      email: resolvedEmail,
      phoneNumber: fbUser.phoneNumber,
      createdAt: fbUser.metadata.creationTime ?? DateTime.now(),
    );

    if (resolvedEmail.isNotEmpty) {
      try {
        await docRef.set(
          _toFirestoreMap(
            profile,
            photoUrl: fbUser.photoURL ?? fallbackPhotoUrl,
            isCreate: true,
          ),
        );
      } catch (_) {
        // Offline queued or retried on next sync.
      }
    }

    return profile;
  }

  UserProfile _fromFirestoreMap(
    String uid,
    Map<String, dynamic> data,
    User fbUser,
  ) {
    final createdRaw = data['createdAt'] ?? data['created_at'];
    DateTime createdAt;
    if (createdRaw is Timestamp) {
      createdAt = createdRaw.toDate();
    } else if (createdRaw is String) {
      createdAt = DateTime.tryParse(createdRaw) ?? DateTime.now();
    } else {
      createdAt = fbUser.metadata.creationTime ?? DateTime.now();
    }

    return UserProfile(
      id: uid,
      fullName: (data['fullName'] ?? data['full_name'] ?? fbUser.displayName ?? 'Member')
          as String,
      email: (data['email'] ?? fbUser.email ?? '') as String,
      phoneNumber: (data['phoneNumber'] ?? data['phone_number']) as String?,
      preferredCurrency:
          (data['preferredCurrency'] ?? data['preferred_currency'] ?? 'TZS')
              as String,
      preferredCurrencySymbol: (data['preferredCurrencySymbol'] ??
              data['preferred_currency_symbol'] ??
              'TSh')
          as String,
      timezone:
          (data['timezone'] ?? 'Africa/Dar_es_Salaam') as String,
      notifyPushEnabled:
          (data['notifyPushEnabled'] ?? data['notify_push_enabled'] ?? true)
              as bool,
      notifyInAppEnabled:
          (data['notifyInAppEnabled'] ?? data['notify_in_app_enabled'] ?? true)
              as bool,
      notifyLowBalanceThreshold:
          ((data['notifyLowBalanceThreshold'] ??
                  data['notify_low_balance_threshold'] ??
                  25000) as num)
              .toDouble(),
      notifyDaysBeforeReplenishment:
          ((data['notifyDaysBeforeReplenishment'] ??
                  data['notify_days_before_replenishment'] ??
                  3) as num)
              .toInt(),
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> _toFirestoreMap(
    UserProfile profile, {
    String? photoUrl,
    required bool isCreate,
  }) {
    final cleanPhone =
        profile.phoneNumber != null && profile.phoneNumber!.trim().isNotEmpty
            ? profile.phoneNumber!.trim()
            : null;
    final cleanPhotoUrl = photoUrl != null &&
            (photoUrl.startsWith('https://') || photoUrl.startsWith('http://'))
        ? photoUrl
        : null;

    final map = <String, dynamic>{
      'fullName': profile.fullName.trim(),
      'email': profile.email.trim().toLowerCase(),
      'phoneNumber': cleanPhone,
      'preferredCurrency': profile.preferredCurrency,
      'preferredCurrencySymbol': profile.preferredCurrencySymbol,
      'timezone': profile.timezone,
      'notifyPushEnabled': profile.notifyPushEnabled,
      'notifyInAppEnabled': profile.notifyInAppEnabled,
      'notifyLowBalanceThreshold': profile.notifyLowBalanceThreshold,
      'notifyDaysBeforeReplenishment': profile.notifyDaysBeforeReplenishment,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };
    if (cleanPhotoUrl != null) {
      map['photoUrl'] = cleanPhotoUrl;
    }
    if (isCreate) {
      map['id'] = profile.id;
      map['createdAt'] = Timestamp.fromDate(profile.createdAt);
    }
    return map;
  }

  AppException _mapFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return const ValidationException('Please enter a valid email address.');
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return const ValidationException('Invalid email or password.');
      case 'email-already-in-use':
        return const ValidationException(
          'An account with this email already exists.',
        );
      case 'weak-password':
        return const ValidationException(
          'Password is too weak. Use at least 8 characters.',
        );
      case 'user-disabled':
        return const AppException(
          'This account has been disabled.',
          code: 'user-disabled',
        );
      case 'too-many-requests':
        return const AppException(
          'Too many attempts. Please wait a moment and try again.',
          code: 'too-many-requests',
        );
      case 'requires-recent-login':
        return const AppException(
          'Please log out and sign back in to update your password.',
          code: 'requires-recent-login',
        );
      case 'network-request-failed':
        return const AppException(
          'Network error. Check your internet connection and try again.',
          code: 'network-request-failed',
        );
      default:
        return AppException(e.message ?? 'Authentication error (${e.code}).');
    }
  }
}
