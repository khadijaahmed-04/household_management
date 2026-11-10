package rahisi.com.household_management

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.os.Build
import androidx.core.app.NotificationCompat

/**
 * Fires scheduled NyumbaSmart supply reminders in the background even when the
 * app is closed, displaying a high-priority heads-up pop-up notification banner
 * with sound & vibration (just like an incoming WhatsApp message) at the top of the screen.
 */
class SupplyReminderReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val title = intent.getStringExtra(EXTRA_TITLE) ?: "🏠 NyumbaSmart Reminder"
        val body = intent.getStringExtra(EXTRA_BODY)
            ?: "Some household supplies are running low. Tap to view your household predictions."
        val notificationId = intent.getIntExtra(
            EXTRA_NOTIFICATION_ID,
            (System.currentTimeMillis() % 100000).toInt()
        )

        showHeadsUpReminderNotification(
            context = context,
            notificationId = notificationId,
            title = title,
            body = body
        )
    }

    companion object {
        const val CHANNEL_ID = "nyumbasmart_popup_reminders_v2"
        const val CHANNEL_NAME = "NyumbaSmart Pop-Up Reminders"
        const val EXTRA_TITLE = "extra_title"
        const val EXTRA_BODY = "extra_body"
        const val EXTRA_NOTIFICATION_ID = "extra_notification_id"

        fun ensureChannelCreated(context: Context) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val manager =
                    context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                val soundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
                val audioAttributes = AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build()

                val channel = NotificationChannel(
                    CHANNEL_ID,
                    CHANNEL_NAME,
                    NotificationManager.IMPORTANCE_HIGH
                ).apply {
                    description =
                        "Heads-up pop-up reminders when household supplies are nearly finished"
                    enableVibration(true)
                    vibrationPattern = longArrayOf(0, 250, 150, 250)
                    setSound(soundUri, audioAttributes)
                }
                manager.createNotificationChannel(channel)
            }
        }

        fun showHeadsUpReminderNotification(
            context: Context,
            notificationId: Int,
            title: String,
            body: String
        ) {
            try {
                ensureChannelCreated(context)
                val manager =
                    context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

                val openAppIntent = Intent(context, MainActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                }
                val pendingOpen = PendingIntent.getActivity(
                    context,
                    notificationId,
                    openAppIntent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )

                val cleanBody = body.replace("*", "")
                val soundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)

                val notification = NotificationCompat.Builder(context, CHANNEL_ID)
                    .setSmallIcon(R.mipmap.ic_launcher)
                    .setContentTitle(title)
                    .setContentText(cleanBody)
                    .setStyle(NotificationCompat.BigTextStyle().bigText(cleanBody))
                    .setPriority(NotificationCompat.PRIORITY_MAX)
                    .setCategory(NotificationCompat.CATEGORY_MESSAGE)
                    .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                    .setDefaults(NotificationCompat.DEFAULT_ALL)
                    .setSound(soundUri)
                    .setVibrate(longArrayOf(0, 250, 150, 250))
                    .setAutoCancel(true)
                    .setContentIntent(pendingOpen)
                    .build()

                manager.notify(notificationId, notification)
            } catch (_: Exception) {
                // Ignore if notification permission is not yet granted
            }
        }
    }
}

