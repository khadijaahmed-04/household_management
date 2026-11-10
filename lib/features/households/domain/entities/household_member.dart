import 'package:equatable/equatable.dart';

enum HouseholdRole {
  admin,
  member, // Read-only access in future member login release
}

class HouseholdMember extends Equatable {
  final String id;
  final String householdId;
  final String? linkedUserId;
  final String displayName;
  final String? email;
  final String? phoneNumber;
  final HouseholdRole role;
  final String avatarColor;
  final bool isActive;
  final DateTime joinedAt;

  const HouseholdMember({
    required this.id,
    required this.householdId,
    this.linkedUserId,
    required this.displayName,
    this.email,
    this.phoneNumber,
    this.role = HouseholdRole.member,
    this.avatarColor = '#3B82F6',
    this.isActive = true,
    required this.joinedAt,
  });

  bool get isAdmin => role == HouseholdRole.admin;
  bool get isReadOnlyMember => role == HouseholdRole.member;

  HouseholdMember copyWith({
    String? displayName,
    String? email,
    String? phoneNumber,
    HouseholdRole? role,
    String? avatarColor,
    bool? isActive,
  }) {
    return HouseholdMember(
      id: id,
      householdId: householdId,
      linkedUserId: linkedUserId,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      avatarColor: avatarColor ?? this.avatarColor,
      isActive: isActive ?? this.isActive,
      joinedAt: joinedAt,
    );
  }

  factory HouseholdMember.fromJson(Map<String, dynamic> json) {
    return HouseholdMember(
      id: json['id'] as String,
      householdId: json['household_id'] as String,
      linkedUserId: json['linked_user_id'] as String?,
      displayName: json['display_name'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      role: (json['role'] as String?) == 'admin'
          ? HouseholdRole.admin
          : HouseholdRole.member,
      avatarColor: json['avatar_color'] as String? ?? '#3B82F6',
      isActive: json['is_active'] as bool? ?? true,
      joinedAt: json['joined_at'] != null
          ? DateTime.parse(json['joined_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'household_id': householdId,
      'linked_user_id': linkedUserId,
      'display_name': displayName,
      'email': email,
      'phone_number': phoneNumber,
      'role': role == HouseholdRole.admin ? 'admin' : 'member',
      'avatar_color': avatarColor,
      'is_active': isActive,
      'joined_at': joinedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        householdId,
        linkedUserId,
        displayName,
        email,
        phoneNumber,
        role,
        avatarColor,
        isActive,
        joinedAt,
      ];
}

