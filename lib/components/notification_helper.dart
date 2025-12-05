import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize notification plugin
  static Future<void> initNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const WindowsInitializationSettings windowsSettings =
        WindowsInitializationSettings(
          appName: 'البخاري',
          appUserModelId: '111111111111',
          guid: 'b604fb70-ff9f-4aec-8885-d10aab73d547',
        );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      windows: windowsSettings,
    );

    await _notificationsPlugin.initialize(initSettings);
    tz.initializeTimeZones();
  }

  /// Schedule daily hadith reminder at specific time (e.g., 8:00 AM)
  static Future<void> scheduleDailyReminder({
    int hour = 8,
    int minute = 0,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Cancel existing notification if any
      await _notificationsPlugin.cancelAll();

      // Get local timezone
      tz.initializeTimeZones();
      final location = tz.getLocation(tz.local.name);

      // Calculate next occurrence
      final now = tz.TZDateTime.now(location);
      var scheduledDate = tz.TZDateTime(
        location,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      // If time has passed today, schedule for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      // Schedule the notification
      await _notificationsPlugin.zonedSchedule(
        999, // Notification ID for daily reminder
        'تذكير يومي 📖',
        'حان وقت قراءة الحديث الشريف من صحيح البخاري',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_reminder_channel_id',
            'تذكير يومي',
            channelDescription: 'تذكير يومي لقراءة الأحاديث',
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents:
            DateTimeComponents.time, // Repeat daily at same time
      );

      // Save preference
      await prefs.setBool('dailyReminderEnabled', true);
      await prefs.setInt('reminderHour', hour);
      await prefs.setInt('reminderMinute', minute);
    } catch (e) {
      print('Error scheduling daily reminder: $e');
    }
  }

  /// Disable daily reminder
  static Future<void> disableDailyReminder() async {
    try {
      await _notificationsPlugin.cancel(999); // Cancel daily reminder
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('dailyReminderEnabled', false);
    } catch (e) {
      print('Error disabling daily reminder: $e');
    }
  }

  /// Check if daily reminder is enabled
  static Future<bool> isDailyReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('dailyReminderEnabled') ?? false;
  }

  /// Get current reminder time
  static Future<(int hour, int minute)> getReminderTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt('reminderHour') ?? 8;
    final minute = prefs.getInt('reminderMinute') ?? 0;
    return (hour, minute);
  }

  /// Show a test notification immediately
  static Future<void> showTestNotification() async {
    try {
      await _notificationsPlugin.show(
        0,
        'اختبار التنبيهات 📬',
        'هذا اختبار لتنبيهات التطبيق',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_channel_id',
            'اختبار',
            channelDescription: 'قناة اختبار التنبيهات',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    } catch (e) {
      print('Error showing test notification: $e');
    }
  }
}
