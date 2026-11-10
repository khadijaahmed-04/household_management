import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? phoneNumber;
  final String preferredCurrency;
  final String preferredCurrencySymbol;
  final String timezone;
  final bool notifyPushEnabled;
  final bool notifyInAppEnabled;
  final double notifyLowBalanceThreshold;
  final int notifyDaysBeforeReplenishment;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    this.phoneNumber,
    this.preferredCurrency = 'TZS',
    this.preferredCurrencySymbol = 'TSh',
    this.timezone = 'Africa/Dar_es_Salaam',
    this.notifyPushEnabled = true,
    this.notifyInAppEnabled = true,
    this.notifyLowBalanceThreshold = 25000,
    this.notifyDaysBeforeReplenishment = 3,
    required this.createdAt,
  });

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? preferredCurrency,
    String? preferredCurrencySymbol,
    String? timezone,
    bool? notifyPushEnabled,
    bool? notifyInAppEnabled,
    double? notifyLowBalanceThreshold,
    int? notifyDaysBeforeReplenishment,
  }) {
    return UserProfile(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      preferredCurrency: preferredCurrency ?? this.preferredCurrency,
      preferredCurrencySymbol:
          preferredCurrencySymbol ?? this.preferredCurrencySymbol,
      timezone: timezone ?? this.timezone,
      notifyPushEnabled: notifyPushEnabled ?? this.notifyPushEnabled,
      notifyInAppEnabled: notifyInAppEnabled ?? this.notifyInAppEnabled,
      notifyLowBalanceThreshold:
          notifyLowBalanceThreshold ?? this.notifyLowBalanceThreshold,
      notifyDaysBeforeReplenishment:
          notifyDaysBeforeReplenishment ?? this.notifyDaysBeforeReplenishment,
      createdAt: createdAt,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      fullName: json['full_name'] as String? ?? 'Administrator',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phone_number'] as String?,
      preferredCurrency: json['preferred_currency'] as String? ?? 'TZS',
      preferredCurrencySymbol:
          json['preferred_currency_symbol'] as String? ?? 'TSh',
      timezone: json['timezone'] as String? ?? 'Africa/Dar_es_Salaam',
      notifyPushEnabled: json['notify_push_enabled'] as bool? ?? true,
      notifyInAppEnabled: json['notify_in_app_enabled'] as bool? ?? true,
      notifyLowBalanceThreshold:
          (json['notify_low_balance_threshold'] as num?)?.toDouble() ?? 25000.0,
      notifyDaysBeforeReplenishment:
          (json['notify_days_before_replenishment'] as num?)?.toInt() ?? 3,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'preferred_currency': preferredCurrency,
      'preferred_currency_symbol': preferredCurrencySymbol,
      'timezone': timezone,
      'notify_push_enabled': notifyPushEnabled,
      'notify_in_app_enabled': notifyInAppEnabled,
      'notify_low_balance_threshold': notifyLowBalanceThreshold,
      'notify_days_before_replenishment': notifyDaysBeforeReplenishment,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phoneNumber,
        preferredCurrency,
        preferredCurrencySymbol,
        timezone,
        notifyPushEnabled,
        notifyInAppEnabled,
        notifyLowBalanceThreshold,
        notifyDaysBeforeReplenishment,
        createdAt,
      ];
}

