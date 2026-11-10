class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => message;
}

class InsufficientBalanceException extends AppException {
  final double availableBalance;
  final double requestedAmount;
  final String currencySymbol;

  InsufficientBalanceException({
    required this.availableBalance,
    required this.requestedAmount,
    this.currencySymbol = 'TSh',
  }) : super(
          'Insufficient household wallet balance. Available: $currencySymbol ${availableBalance.toStringAsFixed(0)}, '
          'Required: $currencySymbol ${requestedAmount.toStringAsFixed(0)}.',
          code: 'INSUFFICIENT_BALANCE',
        );
}

class UnauthorizedHouseholdAccessException extends AppException {
  const UnauthorizedHouseholdAccessException([
    super.message =
        'Unauthorized access: You do not have permission to modify or view this household.',
  ]) : super(code: 'UNAUTHORIZED_HOUSEHOLD_ACCESS');
}

class ReadOnlyMemberRestrictionException extends AppException {
  const ReadOnlyMemberRestrictionException([
    super.message =
        'Read-only member accounts cannot create, edit, or delete household financial records.',
  ]) : super(code: 'READ_ONLY_MEMBER_RESTRICTION');
}

class DuplicateTransactionException extends AppException {
  const DuplicateTransactionException([
    super.message =
        'Duplicate transaction submission detected and prevented.',
  ]) : super(code: 'DUPLICATE_SUBMISSION');
}

class ValidationException extends AppException {
  const ValidationException(super.message) : super(code: 'VALIDATION_ERROR');
}

