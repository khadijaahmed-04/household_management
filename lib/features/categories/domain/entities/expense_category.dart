import 'package:equatable/equatable.dart';

class ExpenseCategory extends Equatable {
  final String id;
  final String householdId;
  final String name;
  final String slug;
  final String iconName;
  final String colorHex;
  final bool isDefault;
  final bool isActive;
  final bool tracksConsumption;
  final String supplyType;

  const ExpenseCategory({
    required this.id,
    required this.householdId,
    required this.name,
    required this.slug,
    this.iconName = 'category',
    this.colorHex = '#3B82F6',
    this.isDefault = false,
    this.isActive = true,
    this.tracksConsumption = false,
    this.supplyType = 'none',
  });

  ExpenseCategory copyWith({
    String? name,
    String? slug,
    String? iconName,
    String? colorHex,
    bool? isActive,
  }) {
    return ExpenseCategory(
      id: id,
      householdId: householdId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      isDefault: isDefault,
      isActive: isActive ?? this.isActive,
      tracksConsumption: tracksConsumption,
      supplyType: supplyType,
    );
  }

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
      id: json['id'] as String,
      householdId: json['household_id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      iconName: json['icon_name'] as String? ?? 'category',
      colorHex: json['color_hex'] as String? ?? '#3B82F6',
      isDefault: json['is_default'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      tracksConsumption: json['tracks_consumption'] as bool? ?? false,
      supplyType: json['supply_type'] as String? ?? 'none',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'household_id': householdId,
      'name': name,
      'slug': slug,
      'icon_name': iconName,
      'color_hex': colorHex,
      'is_default': isDefault,
      'is_active': isActive,
      'tracks_consumption': tracksConsumption,
      'supply_type': supplyType,
    };
  }

  static List<ExpenseCategory> createDefaultCategoriesForHousehold(
    String householdId,
  ) {
    return [
      ExpenseCategory(
        id: 'cat-${householdId}-groceries',
        householdId: householdId,
        name: 'Groceries',
        slug: 'groceries',
        iconName: 'shopping_basket',
        colorHex: '#10B981',
        isDefault: true,
        tracksConsumption: true,
        supplyType: 'grocery',
      ),
      ExpenseCategory(
        id: 'cat-${householdId}-electricity',
        householdId: householdId,
        name: 'Electricity',
        slug: 'electricity',
        iconName: 'bolt',
        colorHex: '#F59E0B',
        isDefault: true,
        tracksConsumption: true,
        supplyType: 'electricity',
      ),
      ExpenseCategory(
        id: 'cat-${householdId}-gas',
        householdId: householdId,
        name: 'Gas',
        slug: 'gas',
        iconName: 'local_fire_department',
        colorHex: '#F97316',
        isDefault: true,
        tracksConsumption: true,
        supplyType: 'gas',
      ),
      ExpenseCategory(
        id: 'cat-${householdId}-water',
        householdId: householdId,
        name: 'Water',
        slug: 'water',
        iconName: 'water_drop',
        colorHex: '#06B6D4',
        isDefault: true,
        tracksConsumption: true,
        supplyType: 'water',
      ),
      ExpenseCategory(
        id: 'cat-${householdId}-internet',
        householdId: householdId,
        name: 'Internet',
        slug: 'internet',
        iconName: 'wifi',
        colorHex: '#6366F1',
        isDefault: true,
        tracksConsumption: false,
        supplyType: 'recurring_bill',
      ),
      ExpenseCategory(
        id: 'cat-${householdId}-rent',
        householdId: householdId,
        name: 'Rent',
        slug: 'rent',
        iconName: 'home',
        colorHex: '#8B5CF6',
        isDefault: true,
        tracksConsumption: false,
        supplyType: 'recurring_bill',
      ),
      ExpenseCategory(
        id: 'cat-${householdId}-cleaning',
        householdId: householdId,
        name: 'Cleaning supplies',
        slug: 'cleaning_supplies',
        iconName: 'cleaning_services',
        colorHex: '#14B8A6',
        isDefault: true,
      ),
      ExpenseCategory(
        id: 'cat-${householdId}-maintenance',
        householdId: householdId,
        name: 'Household maintenance',
        slug: 'household_maintenance',
        iconName: 'build',
        colorHex: '#EC4899',
        isDefault: true,
      ),
      ExpenseCategory(
        id: 'cat-${householdId}-transport',
        householdId: householdId,
        name: 'Transportation',
        slug: 'transportation',
        iconName: 'directions_bus',
        colorHex: '#3B82F6',
        isDefault: true,
      ),
      ExpenseCategory(
        id: 'cat-${householdId}-other',
        householdId: householdId,
        name: 'Other',
        slug: 'other',
        iconName: 'more_horiz',
        colorHex: '#6B7280',
        isDefault: true,
      ),
    ];
  }

  @override
  List<Object?> get props => [
        id,
        householdId,
        name,
        slug,
        iconName,
        colorHex,
        isDefault,
        isActive,
        tracksConsumption,
        supplyType,
      ];
}

