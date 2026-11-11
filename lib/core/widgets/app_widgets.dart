import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/formatters.dart';

/// Standard 18px rounded surface card with subtle border and restrained shadow.
class AppSurfaceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;

  const AppSurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 18,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark ? AppColors.darkSurface : AppColors.surface;
    final defaultBorder =
        isDark ? AppColors.darkSoftGreenBorder : AppColors.softGreenBorder;

    final container = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor ?? defaultBorder, width: 1.4),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF24332B).withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    if (onTap == null) return container;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: container,
      ),
    );
  }
}

/// Section header (17-18 px bold) with optional trailing action button.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final double fontSize;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
    this.fontSize = 17,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final accentGreen =
        isDark ? const Color(0xFF34C486) : AppColors.primaryGreen;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                color: textPrimary,
                letterSpacing: -0.2,
              ),
            ),
          ),
          if (actionLabel != null && onActionTap != null)
            TextButton(
              onPressed: onActionTap,
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: accentGreen,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionLabel!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: accentGreen,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: accentGreen,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Friendly rounded status pill for replenishment days, confidence, or categories.
class StatusPill extends StatelessWidget {
  final String label;
  final Color foregroundColor;
  final Color backgroundColor;
  final IconData? icon;

  const StatusPill({
    super.key,
    required this.label,
    this.foregroundColor = AppColors.primaryGreen,
    this.backgroundColor = AppColors.softGreen,
    this.icon,
  });

  factory StatusPill.warning(String label, {IconData? icon}) => StatusPill(
        label: label,
        foregroundColor: AppColors.warning,
        backgroundColor: AppColors.warningSoft,
        icon: icon,
      );

  factory StatusPill.error(String label, {IconData? icon}) => StatusPill(
        label: label,
        foregroundColor: AppColors.error,
        backgroundColor: AppColors.errorSoft,
        icon: icon,
      );

  factory StatusPill.info(String label, {IconData? icon}) => StatusPill(
        label: label,
        foregroundColor: AppColors.info,
        backgroundColor: AppColors.infoSoft,
        icon: icon,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: foregroundColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable Transaction Row Card for Dashboard & Activity History.
class TransactionRowCard extends StatelessWidget {
  final String title;
  final String memberName;
  final String categoryName;
  final DateTime date;
  final double signedAmount;
  final String currencySymbol;
  final double? runningBalanceAfter;
  final VoidCallback? onTap;

  const TransactionRowCard({
    super.key,
    required this.title,
    required this.memberName,
    required this.categoryName,
    required this.date,
    required this.signedAmount,
    required this.currencySymbol,
    this.runningBalanceAfter,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCredit = signedAmount >= 0;
    final accentColor = isCredit
        ? (isDark ? const Color(0xFF34C486) : AppColors.primaryGreen)
        : AppColors.error;
    final tintColor = isCredit
        ? (isDark ? AppColors.darkSoftGreen : AppColors.softGreen)
        : (isDark
            ? AppColors.error.withValues(alpha: 0.18)
            : AppColors.errorSoft);
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return AppSurfaceCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: tintColor,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              isCredit
                  ? Icons.south_west_rounded
                  : Icons.shopping_bag_outlined,
              color: accentColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$memberName • $categoryName • ${AppFormatters.formatDate(date)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                AppFormatters.formatCurrency(
                  signedAmount,
                  symbol: currencySymbol,
                  showSign: true,
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                ),
              ),
              if (runningBalanceAfter != null) ...[
                const SizedBox(height: 3),
                Text(
                  'Bal: ${AppFormatters.formatCurrency(runningBalanceAfter!, symbol: currencySymbol)}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Friendly Supply Insight / Replenishment Prediction Card.
class SupplyInsightCard extends StatelessWidget {
  final String supplyName;
  final IconData icon;
  final DateTime? nextExpectedDate;
  final double? averageIntervalDays;
  final int? daysLeft;
  final String confidenceLabel;
  final VoidCallback? onTap;
  final VoidCallback? onShareAlert;

  const SupplyInsightCard({
    super.key,
    required this.supplyName,
    required this.icon,
    required this.nextExpectedDate,
    required this.averageIntervalDays,
    required this.daysLeft,
    required this.confidenceLabel,
    this.onTap,
    this.onShareAlert,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isUrgent = daysLeft != null && daysLeft! <= 3;
    final bool isOverdue = daysLeft != null && daysLeft! <= 0;

    final Color pillFg = isOverdue
        ? AppColors.error
        : (isUrgent
            ? AppColors.warning
            : (isDark ? const Color(0xFF34C486) : AppColors.primaryGreen));
    final Color pillBg = isOverdue
        ? (isDark
            ? AppColors.error.withValues(alpha: 0.2)
            : AppColors.errorSoft)
        : (isUrgent
            ? (isDark
                ? AppColors.warning.withValues(alpha: 0.2)
                : AppColors.warningSoft)
            : (isDark ? AppColors.darkSoftGreen : AppColors.softGreen));

    final String countdownLabel = daysLeft == null
        ? confidenceLabel
        : (daysLeft! <= 0
            ? 'Replenish now'
            : (daysLeft == 1 ? 'In 1 day' : 'In ~$daysLeft days'));

    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return AppSurfaceCard(
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: pillBg,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: pillFg, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  supplyName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  nextExpectedDate != null
                      ? 'Expected ${AppFormatters.formatDate(nextExpectedDate!)} • ~${averageIntervalDays?.toStringAsFixed(0) ?? '-'}d cycle'
                      : 'Record at least 2 purchases to predict cycle',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          StatusPill(
            label: countdownLabel,
            foregroundColor: pillFg,
            backgroundColor: pillBg,
          ),
          if (onShareAlert != null) ...[
            const SizedBox(width: 6),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onShareAlert,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSoftGreen : AppColors.softGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.send_rounded,
                  size: 16,
                  color: isDark
                      ? const Color(0xFF34C486)
                      : AppColors.primaryGreen,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class EmptyStateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return AppSurfaceCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSoftGreen : AppColors.softGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: isDark ? const Color(0xFF34C486) : AppColors.primaryGreen,
              size: 30,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: textSecondary,
              height: 1.45,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

class SyncStatusBanner extends StatelessWidget {
  final bool isOnline;
  final String message;

  const SyncStatusBanner({
    super.key,
    required this.isOnline,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isOnline
        ? (isDark ? AppColors.darkSoftGreen : AppColors.softGreen)
        : (isDark
            ? AppColors.warning.withValues(alpha: 0.2)
            : AppColors.warningSoft);
    final borderColor = isOnline
        ? (isDark ? AppColors.darkSoftGreenBorder : AppColors.softGreenBorder)
        : AppColors.warning;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(
            isOnline ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
            size: 17,
            color: isOnline
                ? (isDark ? const Color(0xFF34C486) : AppColors.primaryGreen)
                : AppColors.warning,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<bool> showDestructiveConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
}) async {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
      ),
      content: Text(
        message,
        style: TextStyle(
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
          ),
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
