import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/predictions/domain/entities/prediction_entity.dart';
import '../constants/app_colors.dart';
import 'formatters.dart';

class AutoAlertSettings {
  final bool isAutoEnabled;
  final int reminderHour;
  final int reminderMinute;

  const AutoAlertSettings({
    this.isAutoEnabled = true,
    this.reminderHour = 8,
    this.reminderMinute = 0,
  });

  String get formattedTime {
    final h = reminderHour.toString().padLeft(2, '0');
    final m = reminderMinute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  AutoAlertSettings copyWith({
    bool? isAutoEnabled,
    int? reminderHour,
    int? reminderMinute,
  }) {
    return AutoAlertSettings(
      isAutoEnabled: isAutoEnabled ?? this.isAutoEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
    );
  }
}

class AutoAlertController extends StateNotifier<AutoAlertSettings> {
  static const _enabledKey = 'nyumbasmart_auto_alert_enabled_v2';
  static const _hourKey = 'nyumbasmart_reminder_hour_v2';
  static const _minuteKey = 'nyumbasmart_reminder_minute_v2';

  AutoAlertController() : super(const AutoAlertSettings()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final enabled = prefs.getBool(_enabledKey);
      final hour = prefs.getInt(_hourKey);
      final minute = prefs.getInt(_minuteKey);
      state = AutoAlertSettings(
        isAutoEnabled: enabled ?? true,
        reminderHour: hour ?? 8,
        reminderMinute: minute ?? 0,
      );
    } catch (_) {}
  }

  Future<void> saveAlertPreferences({
    bool? isAutoEnabled,
    int? reminderHour,
    int? reminderMinute,
  }) async {
    final next = state.copyWith(
      isAutoEnabled: isAutoEnabled,
      reminderHour: reminderHour,
      reminderMinute: reminderMinute,
    );
    state = next;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_enabledKey, next.isAutoEnabled);
      await prefs.setInt(_hourKey, next.reminderHour);
      await prefs.setInt(_minuteKey, next.reminderMinute);
    } catch (_) {}
  }
}

final autoAlertSettingsProvider =
    StateNotifierProvider<AutoAlertController, AutoAlertSettings>(
  (ref) => AutoAlertController(),
);

/// Free Native Android Pop-Up Reminder Scheduler.
/// Uses Android's AlarmManager + BroadcastReceiver so reminders pop down from
/// the top of the phone with sound & vibration (just like a WhatsApp message)
/// even when the user has closed the NyumbaSmart app!
class ShareLauncher {
  ShareLauncher._();

  static const MethodChannel _channel = MethodChannel('nyumbasmart/share');
  static const String _dispatchedAlertsKey =
      'nyumbasmart_dispatched_popup_reminders_v2';

  static Future<void> requestAlertPermissions() async {
    try {
      await _channel.invokeMethod('requestAlertPermissions');
    } catch (_) {}
  }

  /// Displays an immediate heads-up pop-up notification banner at the top of the phone.
  static Future<bool> showInstantPopupReminder({
    required String title,
    required String message,
    int? reminderId,
  }) async {
    try {
      await _channel.invokeMethod('showSystemNotification', {
        'title': title,
        'text': message,
        if (reminderId != null) 'reminderId': reminderId,
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Schedules a background OS alarm via Android's AlarmManager that fires
  /// even when the NyumbaSmart app is completely closed/killed.
  static Future<bool> scheduleBackgroundPopupReminder({
    required String title,
    required String message,
    required Duration delay,
    int? reminderId,
  }) async {
    try {
      await _channel.invokeMethod('scheduleBackgroundReminder', {
        'title': title,
        'text': message,
        'delayMillis': delay.inMilliseconds,
        'reminderId':
            reminderId ?? (DateTime.now().millisecondsSinceEpoch % 100000),
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Automatically checks if any household supply is within <= 3 days of running out,
  /// pops up a WhatsApp-style heads-up notification, and schedules background OS alarms
  /// for upcoming supply replenishments so alerts arrive even when the app is closed.
  static Future<void> checkAndAutoSendLowSupplyAlerts({
    required String householdId,
    required String householdName,
    required String currencySymbol,
    required double availableBalance,
    required List<SupplyPrediction> predictions,
    bool forceSendNow = false,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isEnabled =
          prefs.getBool(AutoAlertController._enabledKey) ?? true;
      if (!isEnabled && !forceSendNow) return;

      final reminderHour = prefs.getInt(AutoAlertController._hourKey) ?? 8;
      final reminderMinute = prefs.getInt(AutoAlertController._minuteKey) ?? 0;

      final dispatched =
          (prefs.getStringList(_dispatchedAlertsKey) ?? <String>[]).toSet();

      final referenceToday = DateTime(2026, 11, 9);
      final urgent = <SupplyPrediction>[];

      for (final p in predictions) {
        final daysLeft = p.daysUntilNextPurchase(referenceToday);
        if (daysLeft != null && daysLeft <= 3) {
          final cycleKey =
              '${householdId}_${p.supplyId}_${p.effectiveNextDate?.toIso8601String() ?? 'due'}';
          if (forceSendNow || !dispatched.contains(cycleKey)) {
            urgent.add(p);
            dispatched.add(cycleKey);
          }
        }
      }

      if (urgent.isEmpty) return;

      await prefs.setStringList(_dispatchedAlertsKey, dispatched.toList());

      final lines = urgent.map((p) {
        final days = p.daysUntilNextPurchase(referenceToday) ?? 0;
        final dateStr = p.effectiveNextDate != null
            ? AppFormatters.formatDate(p.effectiveNextDate!)
            : 'soon';
        return '• ${p.supplyName}: ${days <= 0 ? 'Finished / Refill now' : '~$days days left (expected $dateStr)'}';
      }).join('\n');

      final message = '⚠️ Supplies nearly finished:\n'
          '$lines\n'
          '💰 Shared Balance: ${AppFormatters.formatCurrency(availableBalance, symbol: currencySymbol)}';

      final title = '🏠 NyumbaSmart • $householdName';

      // 1. Pop up immediate heads-up notification banner (like a WhatsApp message)
      await showInstantPopupReminder(
        title: title,
        message: message,
        reminderId: householdId.hashCode.abs() % 50000 + 100,
      );

      // 2. Also schedule a background OS alarm for the user's configured daily reminder time
      // so if they are outside the app, Android wakes up and pops up the reminder!
      final now = DateTime.now();
      var nextDailyTime = DateTime(
        now.year,
        now.month,
        now.day,
        reminderHour,
        reminderMinute,
      );
      if (nextDailyTime.isBefore(now.add(const Duration(minutes: 1)))) {
        nextDailyTime = nextDailyTime.add(const Duration(days: 1));
      }
      await scheduleBackgroundPopupReminder(
        title: title,
        message: message,
        delay: nextDailyTime.difference(now),
        reminderId: householdId.hashCode.abs() % 50000 + 200,
      );
    } catch (_) {}
  }

  /// Shows a bottom sheet where the user can set a free native pop-up reminder
  /// (including a 5-second background test so they can close the app and watch it pop up!)
  /// or copy the summary text to clipboard.
  static Future<void> showShareAlertSheet({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    if (!context.mounted) return;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 18,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        isDark ? AppColors.darkSoftGreen : AppColors.softGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.notifications_active_rounded,
                    color: isDark
                        ? const Color(0xFF34C486)
                        : AppColors.primaryGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkBackground
                    : AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              child: Text(
                message.replaceAll('*', ''),
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () async {
                Navigator.of(ctx).pop();
                await scheduleBackgroundPopupReminder(
                  title: title,
                  message: message,
                  delay: const Duration(seconds: 5),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.primaryGreen,
                      duration: Duration(seconds: 4),
                      content: Text(
                        '⏰ Reminder scheduled in 5 seconds! Close or minimize the app now to see it pop up like a message!',
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.alarm_on_rounded, size: 18),
              label: const Text(
                'Remind Me in 5s (Close App to Test!)',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      await showInstantPopupReminder(
                        title: title,
                        message: message,
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_active_outlined,
                      size: 18,
                      color: AppColors.primaryGreen,
                    ),
                    label: const Text('Pop Up Now'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    onPressed: () async {
                      Navigator.of(ctx).pop();
                      final now = DateTime.now();
                      var tomorrowMorning = DateTime(
                        now.year,
                        now.month,
                        now.day + 1,
                        8,
                        0,
                      );
                      await scheduleBackgroundPopupReminder(
                        title: title,
                        message: message,
                        delay: tomorrowMorning.difference(now),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: AppColors.primaryGreen,
                            content: Text(
                              '📅 Background reminder set for tomorrow at 08:00 AM!',
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.schedule_rounded,
                      size: 18,
                      color: AppColors.info,
                    ),
                    label: const Text('Tomorrow 8 AM'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () async {
                await Clipboard.setData(
                  ClipboardData(text: message.replaceAll('*', '')),
                );
                if (ctx.mounted) Navigator.of(ctx).pop();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: AppColors.primaryGreen,
                      content: Text('Summary copied to clipboard!'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.copy_rounded, size: 16),
              label: const Text('Copy Summary to Clipboard'),
            ),
          ],
        ),
      ),
    );
  }
}
