// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';

// class UsageService {
//   static const String key = "opened_days";

//   // تسجيل فتح البرنامج
//   static Future<void> logToday() async {
//     final prefs = await SharedPreferences.getInstance();
//     final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
//     List<String> days = prefs.getStringList(key) ?? [];

//     if (!days.contains(today)) {
//       days.add(today);
//       prefs.setStringList(key, days);
//     }
//   }

//   // جلب كل الأيام
//   static Future<List<DateTime>> getAllDays() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> days = prefs.getStringList(key) ?? [];
//     return days.map((e) => DateTime.parse(e)).toList();
//   }

//   // حساب الستريك (الأيام المتتالية)
//   static Future<int> getStreak() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> days = prefs.getStringList(key) ?? [];
//     if (days.isEmpty) return 0;

//     List<DateTime> sortedDays = days.map((e) => DateTime.parse(e)).toList();
//     sortedDays.sort((a, b) => b.compareTo(a)); // ترتيب تنازلي

//     int streak = 1;
//     DateTime lastDay = sortedDays.first;

//     for (int i = 1; i < sortedDays.length; i++) {
//       if (lastDay.difference(sortedDays[i]).inDays == 1) {
//         streak++;
//         lastDay = sortedDays[i];
//       } else {
//         break;
//       }
//     }

//     return streak;
//   }
// }
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class UsageService {
  static const String key = "opened_days";

  // ============================
  // 🔹 الجزء القديم (فتح الأيام + الستريك)
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

    for (int i = 1; i < sortedDays.length; i++) {
      if (lastDay.difference(sortedDays[i]).inDays == 1) {
        streak++;
        lastDay = sortedDays[i];
      } else {
        break;
      }
    }

    return streak;
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
