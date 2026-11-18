/// Utilities for lossless integer precision currency conversions.
///
/// Prevents IEEE 754 floating-point drift across calculations.
/// 1 standard unit = 100 minor units (cents).
class CurrencyPrecision {
  const CurrencyPrecision._();

  static const int scale = 100;

  /// Converts a decimal currency amount to scaled integer minor units (cents).
  static int toMinorUnits(double amount) {
    return (amount * scale).round();
  }

  /// Converts scaled integer minor units (cents) back to decimal.
  static double fromMinorUnits(int minorUnits) {
    return minorUnits / scale;
  }
}

