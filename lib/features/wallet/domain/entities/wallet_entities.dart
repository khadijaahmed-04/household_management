import 'package:equatable/equatable.dart';

class HouseholdWallet extends Equatable {
  final String id;
  final String householdId;
  final double totalContributions;
  final double totalExpenses;
  final double totalAdjustments;
  final double availableBalance;
  final int version;
  final DateTime? lastTransactionAt;

  const HouseholdWallet({
    required this.id,
    required this.householdId,
    required this.totalContributions,
    required this.totalExpenses,
    this.totalAdjustments = 0.0,
    required this.availableBalance,
    this.version = 1,
    this.lastTransactionAt,
  });

  /// Verifies the fundamental ledger equation:
  /// Available Balance = Total Contributions - Total Expenses + Adjustments
  bool get isLedgerBalanced {
    final computed = totalContributions - totalExpenses + totalAdjustments;
    return (computed - availableBalance).abs() < 0.01;
  }

  HouseholdWallet copyWith({
    double? totalContributions,
    double? totalExpenses,
    double? totalAdjustments,
    double? availableBalance,
    int? version,
    DateTime? lastTransactionAt,
  }) {
    return HouseholdWallet(
      id: id,
      householdId: householdId,
      totalContributions: totalContributions ?? this.totalContributions,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      totalAdjustments: totalAdjustments ?? this.totalAdjustments,
      availableBalance: availableBalance ?? this.availableBalance,
      version: version ?? this.version,
      lastTransactionAt: lastTransactionAt ?? this.lastTransactionAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        householdId,
        totalContributions,
        totalExpenses,
        totalAdjustments,
        availableBalance,
        version,
        lastTransactionAt,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'household_id': householdId,
      'total_contributions': totalContributions,
      'total_expenses': totalExpenses,
      'total_adjustments': totalAdjustments,
      'available_balance': availableBalance,
      'version': version,
      'last_transaction_at': lastTransactionAt?.toIso8601String(),
    };
  }

  factory HouseholdWallet.fromJson(Map<String, dynamic> json) {
    return HouseholdWallet(
      id: json['id'] as String,
      householdId: json['household_id'] as String,
      totalContributions:
          ((json['total_contributions'] ?? 0.0) as num).toDouble(),
      totalExpenses: ((json['total_expenses'] ?? 0.0) as num).toDouble(),
      totalAdjustments:
          ((json['total_adjustments'] ?? 0.0) as num).toDouble(),
      availableBalance:
          ((json['available_balance'] ?? 0.0) as num).toDouble(),
      version: ((json['version'] ?? 1) as num).toInt(),
      lastTransactionAt: json['last_transaction_at'] != null
          ? DateTime.parse(json['last_transaction_at'] as String)
          : null,
    );
  }
}

enum RecordStatus {
  active,
  corrected,
  reversed,
}

class Contribution extends Equatable {
  final String id;
  final String householdId;
  final String memberId;
  final String memberName;
  final String recordedBy;
  final double amount;
  final DateTime contributionDate;
  final String? description;
  final RecordStatus status;
  final String idempotencyKey;
  final DateTime createdAt;

  const Contribution({
    required this.id,
    required this.householdId,
    required this.memberId,
    required this.memberName,
    required this.recordedBy,
    required this.amount,
    required this.contributionDate,
    this.description,
    this.status = RecordStatus.active,
    required this.idempotencyKey,
    required this.createdAt,
  });

  Contribution copyWith({
    RecordStatus? status,
  }) {
    return Contribution(
      id: id,
      householdId: householdId,
      memberId: memberId,
      memberName: memberName,
      recordedBy: recordedBy,
      amount: amount,
      contributionDate: contributionDate,
      description: description,
      status: status ?? this.status,
      idempotencyKey: idempotencyKey,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        householdId,
        memberId,
        memberName,
        recordedBy,
        amount,
        contributionDate,
        description,
        status,
        idempotencyKey,
        createdAt,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'household_id': householdId,
      'member_id': memberId,
      'member_name': memberName,
      'recorded_by': recordedBy,
      'amount': amount,
      'contribution_date': contributionDate.toIso8601String(),
      'description': description,
      'status': status.name,
      'idempotency_key': idempotencyKey,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Contribution.fromJson(Map<String, dynamic> json) {
    return Contribution(
      id: json['id'] as String,
      householdId: json['household_id'] as String,
      memberId: json['member_id'] as String,
      memberName: json['member_name'] as String,
      recordedBy: json['recorded_by'] as String,
      amount: ((json['amount'] ?? 0.0) as num).toDouble(),
      contributionDate: DateTime.parse(json['contribution_date'] as String),
      description: json['description'] as String?,
      status: RecordStatus.values.firstWhere(
        (v) => v.name == json['status'],
        orElse: () => RecordStatus.active,
      ),
      idempotencyKey: json['idempotency_key'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class Expense extends Equatable {
  final String id;
  final String householdId;
  final String categoryId;
  final String categoryName;
  final String paidByMemberId;
  final String paidByMemberName;
  final String recordedBy;
  final String title;
  final double amount;
  final DateTime expenseDate;
  final String? notes;
  final String? receiptUrl;
  final RecordStatus status;
  final String idempotencyKey;
  final DateTime createdAt;

  const Expense({
    required this.id,
    required this.householdId,
    required this.categoryId,
    required this.categoryName,
    required this.paidByMemberId,
    required this.paidByMemberName,
    required this.recordedBy,
    required this.title,
    required this.amount,
    required this.expenseDate,
    this.notes,
    this.receiptUrl,
    this.status = RecordStatus.active,
    required this.idempotencyKey,
    required this.createdAt,
  });

  Expense copyWith({
    RecordStatus? status,
  }) {
    return Expense(
      id: id,
      householdId: householdId,
      categoryId: categoryId,
      categoryName: categoryName,
      paidByMemberId: paidByMemberId,
      paidByMemberName: paidByMemberName,
      recordedBy: recordedBy,
      title: title,
      amount: amount,
      expenseDate: expenseDate,
      notes: notes,
      receiptUrl: receiptUrl,
      status: status ?? this.status,
      idempotencyKey: idempotencyKey,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        householdId,
        categoryId,
        categoryName,
        paidByMemberId,
        paidByMemberName,
        recordedBy,
        title,
        amount,
        expenseDate,
        notes,
        receiptUrl,
        status,
        idempotencyKey,
        createdAt,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'household_id': householdId,
      'category_id': categoryId,
      'category_name': categoryName,
      'paid_by_member_id': paidByMemberId,
      'paid_by_member_name': paidByMemberName,
      'recorded_by': recordedBy,
      'title': title,
      'amount': amount,
      'expense_date': expenseDate.toIso8601String(),
      'notes': notes,
      'receipt_url': receiptUrl,
      'status': status.name,
      'idempotency_key': idempotencyKey,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      householdId: json['household_id'] as String,
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String,
      paidByMemberId: json['paid_by_member_id'] as String,
      paidByMemberName: json['paid_by_member_name'] as String,
      recordedBy: json['recorded_by'] as String,
      title: json['title'] as String,
      amount: ((json['amount'] ?? 0.0) as num).toDouble(),
      expenseDate: DateTime.parse(json['expense_date'] as String),
      notes: json['notes'] as String?,
      receiptUrl: json['receipt_url'] as String?,
      status: RecordStatus.values.firstWhere(
        (v) => v.name == json['status'],
        orElse: () => RecordStatus.active,
      ),
      idempotencyKey: json['idempotency_key'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

enum WalletTransactionType {
  contribution,
  expense,
  adjustmentCredit,
  adjustmentDebit,
  reversal,
}

class WalletTransaction extends Equatable {
  final String id;
  final String householdId;
  final String walletId;
  final WalletTransactionType transactionType;
  final String? referenceContributionId;
  final String? referenceExpenseId;
  final String? parentTransactionId;
  final String? memberId;
  final String memberName;
  final String? categoryId;
  final String categoryName;
  final double amount;
  final double signedAmount;
  final double balanceBefore;
  final double balanceAfter;
  final DateTime transactionDate;
  final String description;
  final String recordedBy;
  final DateTime createdAt;

  const WalletTransaction({
    required this.id,
    required this.householdId,
    required this.walletId,
    required this.transactionType,
    this.referenceContributionId,
    this.referenceExpenseId,
    this.parentTransactionId,
    this.memberId,
    required this.memberName,
    this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.signedAmount,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.transactionDate,
    required this.description,
    required this.recordedBy,
    required this.createdAt,
  });

  bool get isCredit => signedAmount >= 0;

  @override
  List<Object?> get props => [
        id,
        householdId,
        walletId,
        transactionType,
        referenceContributionId,
        referenceExpenseId,
        parentTransactionId,
        memberId,
        memberName,
        categoryId,
        categoryName,
        amount,
        signedAmount,
        balanceBefore,
        balanceAfter,
        transactionDate,
        description,
        recordedBy,
        createdAt,
      ];
}

class AuditLogEntry extends Equatable {
  final String id;
  final String householdId;
  final String actorUserId;
  final String entityType;
  final String entityId;
  final String action;
  final String reason;
  final Map<String, dynamic>? previousState;
  final Map<String, dynamic>? newState;
  final DateTime createdAt;

  const AuditLogEntry({
    required this.id,
    required this.householdId,
    required this.actorUserId,
    required this.entityType,
    required this.entityId,
    required this.action,
    required this.reason,
    this.previousState,
    this.newState,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        householdId,
        actorUserId,
        entityType,
        entityId,
        action,
        reason,
        previousState,
        newState,
        createdAt,
      ];
}

class MonthlyFinancialSummary extends Equatable {
  final DateTime month;
  final double totalContributions;
  final double totalExpenses;
  final double remainingBalance;
  final String? highestExpenseCategory;
  final double highestExpenseCategoryAmount;
  final Map<String, double> contributionsByMember;
  final Map<String, double> expensesByCategory;
  final double previousMonthExpenses;

  const MonthlyFinancialSummary({
    required this.month,
    required this.totalContributions,
    required this.totalExpenses,
    required this.remainingBalance,
    this.highestExpenseCategory,
    this.highestExpenseCategoryAmount = 0.0,
    required this.contributionsByMember,
    required this.expensesByCategory,
    this.previousMonthExpenses = 0.0,
  });

  double get monthOverMonthExpenseChangePercent {
    if (previousMonthExpenses <= 0) return 0.0;
    return ((totalExpenses - previousMonthExpenses) / previousMonthExpenses) *
        100.0;
  }

  @override
  List<Object?> get props => [
        month,
        totalContributions,
        totalExpenses,
        remainingBalance,
        highestExpenseCategory,
        highestExpenseCategoryAmount,
        contributionsByMember,
        expensesByCategory,
        previousMonthExpenses,
      ];
}

