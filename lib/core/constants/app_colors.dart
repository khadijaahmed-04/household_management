import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ===========================================================================
  // CORE DESIGN TOKENS (Friendly, Modern Household Management System)
  // ===========================================================================

  /// Primary green: #167D52
  static const Color primaryGreen = Color(0xFF167D52);
  static const Color primaryGreenDark = Color(0xFF0F5C3C);

  /// Soft green: #E4F3EA
  static const Color softGreen = Color(0xFFE4F3EA);
  static const Color softGreenBorder = Color(0xFF82DAA8);

  /// App background: #F7F8F4
  static const Color background = Color(0xFFF7F8F4);

  /// Card background: #FFFFFF
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F4EF);

  /// Borders & Dividers
  static const Color border = Color(0xFFE4E8E2);

  /// Typography
  /// Primary text: #24332B
  static const Color textPrimary = Color(0xFF24332B);

  /// Secondary text: #758078
  static const Color textSecondary = Color(0xFF758078);
  static const Color textMuted = Color(0xFF9BA59E);

  /// Semantic Status Colors
  /// Warning: #D97706
  static const Color warning = Color(0xFFD97706);
  static const Color warningSoft = Color(0xFFFEF3C7);

  /// Error: #DC5656
  static const Color error = Color(0xFFDC5656);
  static const Color errorSoft = Color(0xFFFEECEC);

  /// Information: #3978C5
  static const Color info = Color(0xFF3978C5);
  static const Color infoSoft = Color(0xFFEBF3FC);

  // ===========================================================================
  // DARK MODE DESIGN TOKENS (Deep Forest Emerald Night Theme)
  // ===========================================================================
  static const Color darkBackground = Color(0xFF0B1712);
  static const Color darkSurface = Color(0xFF13261E);
  static const Color darkSurfaceMuted = Color(0xFF1A3227);
  static const Color darkBorder = Color(0xFF234234);
  static const Color darkTextPrimary = Color(0xFFECF5F0);
  static const Color darkTextSecondary = Color(0xFF9AB0A4);
  static const Color darkSoftGreen = Color(0xFF1B3B2D);
  static const Color darkSoftGreenBorder = Color(0xFF3D916B);

  // ===========================================================================
  // BACKWARD-COMPATIBLE ALIASES (Mapped to the Green Design System)
  // ===========================================================================
  static const Color primaryBlue = primaryGreen;
  static const Color primaryBlueDark = primaryGreenDark;
  static const Color primaryBlueLight = softGreen;

  static const Color successGreen = primaryGreen;
  static const Color successGreenLight = softGreen;

  static const Color secondaryOrange = warning;
  static const Color secondaryOrangeLight = warningSoft;

  static const Color expenseRed = error;
  static const Color expenseRedLight = errorSoft;

  static const Color warningAmber = warning;
  static const Color warningAmberLight = warningSoft;

  static const Color textDark = textPrimary;
}
