import 'package:equatable/equatable.dart';

class Household extends Equatable {
  final String id;
  final String ownerId;
  final String name;
  final String? description;
  final String? address;
  final String currencyCode;
  final String currencySymbol;
  final String timezone;
  final bool allowOverdraft;
  final double lowBalanceThreshold;
  final bool isArchived;
  final DateTime createdAt;

  const Household({
    required this.id,
    required this.ownerId,
    required this.name,
    this.description,
    this.address,
    this.currencyCode = 'TZS',
    this.currencySymbol = 'TSh',
    this.timezone = 'Africa/Dar_es_Salaam',
    this.allowOverdraft = false,
    this.lowBalanceThreshold = 25000.0,
    this.isArchived = false,
    required this.createdAt,
  });

  Household copyWith({
    String? name,
    String? description,
    String? address,
    String? currencyCode,
    String? currencySymbol,
    String? timezone,
    bool? allowOverdraft,
    double? lowBalanceThreshold,
    bool? isArchived,
  }) {
    return Household(
      id: id,
      ownerId: ownerId,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      timezone: timezone ?? this.timezone,
      allowOverdraft: allowOverdraft ?? this.allowOverdraft,
      lowBalanceThreshold: lowBalanceThreshold ?? this.lowBalanceThreshold,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt,
    );
  }

  factory Household.fromJson(Map<String, dynamic> json) {
    return Household(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      address: json['address'] as String?,
      currencyCode: json['currency_code'] as String? ?? 'TZS',
      currencySymbol: json['currency_symbol'] as String? ?? 'TSh',
      timezone: json['timezone'] as String? ?? 'Africa/Dar_es_Salaam',
      allowOverdraft: json['allow_overdraft'] as bool? ?? false,
      lowBalanceThreshold:
          (json['low_balance_threshold'] as num?)?.toDouble() ?? 25000.0,
      isArchived: json['is_archived'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'description': description,
      'address': address,
      'currency_code': currencyCode,
      'currency_symbol': currencySymbol,
      'timezone': timezone,
      'allow_overdraft': allowOverdraft,
      'low_balance_threshold': lowBalanceThreshold,
      'is_archived': isArchived,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        ownerId,
        name,
        description,
        address,
        currencyCode,
        currencySymbol,
        timezone,
        allowOverdraft,
        lowBalanceThreshold,
        isArchived,
        createdAt,
      ];
}

