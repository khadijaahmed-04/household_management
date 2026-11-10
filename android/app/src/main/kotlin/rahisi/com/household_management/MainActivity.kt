package rahisi.com.household_management

import android.Manifest
import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "nyumbasmart/share"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        SupplyReminderReceiver.ensureChannelCreated(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                val text = call.argument<String>("text") ?: ""
                val title = call.argument<String>("title") ?: "🏠 NyumbaSmart Reminder"
                val reminderId = call.argument<Int>("reminderId")
                    ?: (System.currentTimeMillis() % 100000).toInt()
                val delayMillis = (call.argument<Number>("delayMillis")?.toLong()) ?: 5000L

                try {
                    when (call.method) {
                        "requestAlertPermissions" -> {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                                ActivityCompat.requestPermissions(
                                    this,
                                    arrayOf(Manifest.permission.POST_NOTIFICATIONS),
                                    1001
                                )
                            }
                            result.success(true)
                        }
                        "showSystemNotification" -> {
                            SupplyReminderReceiver.showHeadsUpReminderNotification(
                                context = this,
                                notificationId = reminderId,
                                title = title,
                                body = text
                            )
                            result.success(true)
                        }
                        "scheduleBackgroundReminder" -> {
                            scheduleAlarmReminder(
                                reminderId = reminderId,
                                delayMillis = delayMillis,
                                title = title,
                                body = text
                            )
                            result.success(true)
                        }
                        "cancelBackgroundReminder" -> {
                            cancelAlarmReminder(reminderId)
                            result.success(true)
                        }
                        else -> result.notImplemented()
                    }
                } catch (e: Exception) {
                    result.error("REMINDER_ERROR", e.message, null)
                }
            }
    }

    private fun scheduleAlarmReminder(
        reminderId: Int,
        delayMillis: Long,
        title: String,
        body: String
    ) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(this, SupplyReminderReceiver::class.java).apply {
            putExtra(SupplyReminderReceiver.EXTRA_TITLE, title)
            putExtra(SupplyReminderReceiver.EXTRA_BODY, body)
            putExtra(SupplyReminderReceiver.EXTRA_NOTIFICATION_ID, reminderId)
        }
        val pendingIntent = PendingIntent.getBroadcast(
            this,
            reminderId,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val triggerAtMillis = System.currentTimeMillis() + delayMillis.coerceAtLeast(1000L)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager.setAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                triggerAtMillis,
                pendingIntent
            )
        } else {
            alarmManager.set(
                AlarmManager.RTC_WAKEUP,
                triggerAtMillis,
                pendingIntent
            )
        }
    }

    private fun cancelAlarmReminder(reminderId: Int) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(this, SupplyReminderReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            this,
            reminderId,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        alarmManager.cancel(pendingIntent)
    }
}
