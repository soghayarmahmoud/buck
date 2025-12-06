import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class UsageService {
  static const String key = "opened_days";
  static const String lastStreakResetKey = "last_streak_reset_date";

  // ============================
  // 🔹 جزء تتبع الأيام والستريك
  // ============================

  // تسجيل فتح البرنامج
  static Future<void> logToday() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    List<String> days = prefs.getStringList(key) ?? [];

    if (!days.contains(today)) {
      days.add(today);
      prefs.setStringList(key, days);
    }

    // Check if we need to reset streak (skip a day)
    await _checkAndUpdateStreakReset();
  }

  // جلب كل الأيام
  static Future<List<DateTime>> getAllDays() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> days = prefs.getStringList(key) ?? [];
    return days.map((e) => DateTime.parse(e)).toList();
  }

  // حساب الستريك (الأيام المتتالية)
  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> days = prefs.getStringList(key) ?? [];
    if (days.isEmpty) return 0;

    List<DateTime> sortedDays = days.map((e) => DateTime.parse(e)).toList();
    sortedDays.sort((a, b) => b.compareTo(a)); // ترتيب تنازلي

    int streak = 1;
    DateTime lastDay = sortedDays.first;

    // Check if today's date is in the list, if not, streak is broken
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (!days.contains(today)) {
      // If yesterday is the last day, streak is still alive
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayStr = DateFormat('yyyy-MM-dd').format(yesterday);
      if (!days.contains(yesterdayStr)) {
        return 0; // Streak is broken
      }
    }

    for (int i = 1; i < sortedDays.length; i++) {
      final dayDiff = lastDay.difference(sortedDays[i]).inDays;
      if (dayDiff == 1) {
        streak++;
        lastDay = sortedDays[i];
      } else {
        break;
      }
    }

    return streak;
  }

  // Check if we need to reset streak (when a day is skipped)
  static Future<void> _checkAndUpdateStreakReset() async {
    final prefs = await SharedPreferences.getInstance();
    final lastResetStr = prefs.getString(lastStreakResetKey);
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (lastResetStr == null) {
      // First time tracking
      await prefs.setString(lastStreakResetKey, today);
      return;
    }

    final lastResetDate = DateTime.parse(lastResetStr);
    final todayDate = DateTime.parse(today);
    final daysSinceLastReset = todayDate.difference(lastResetDate).inDays;

    // If more than 1 day has passed without opening the app, reset streak
    if (daysSinceLastReset > 1) {
      // Streak was broken, remove old days
      List<String> days = prefs.getStringList(key) ?? [];

      // Keep only today and yesterday (if they exist)
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayStr = DateFormat('yyyy-MM-dd').format(yesterday);

      days.removeWhere((day) => day != today && day != yesterdayStr);
      await prefs.setStringList(key, days);
    }

    await prefs.setString(lastStreakResetKey, today);
  }

  static Future<void> saveDailySeconds(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todayKey = "daily_$today";
    await prefs.setInt(todayKey, seconds);
  }

  /// استرجاع الوقت اليومي (بالثواني)
  static Future<int> getDailySeconds() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todayKey = "daily_$today";
    return prefs.getInt(todayKey) ?? 0;
  }

  /// Get daily seconds for a specific date (yyyy-MM-dd)
  static Future<int> getDailySecondsForDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final key = DateFormat('yyyy-MM-dd').format(date);
    return prefs.getInt('daily_$key') ?? 0;
  }

  /// Get last N days (date -> seconds) with today included. Returns map with DateTime keys.
  static Future<Map<DateTime, int>> getLastNDays(int n) async {
    final Map<DateTime, int> data = {};
    final now = DateTime.now();
    for (int i = 0; i < n; i++) {
      final d = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i));
      final seconds = await getDailySecondsForDate(d);
      data[d] = seconds;
    }
    return data;
  }

  /// حفظ الوقت الكلي (بالثواني)
  static Future<void> saveTotalSeconds(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("total_seconds", seconds);
  }

  /// استرجاع الوقت الكلي (بالثواني)
  static Future<int> getTotalSeconds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("total_seconds") ?? 0;
  }
}
