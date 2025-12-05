# Quick Developer Reference - تطبيق البخاري

## 🎯 الميزات الرئيسية والملفات المسؤولة

### Dark Mode System
**الملف الأساسي:** `lib/themes/theme_provider.dart`

```dart
// تبديل الوضع
themeProvider.toggleTheme();

// الحصول على حالة الوضع
bool isDarkMode = themeProvider.isDarkMode;

// الألوان المستخدمة
Light: #00695C (Teal)
Dark:  #00BFA5 (Teal), #0A0E27 (Background)
```

---

### Daily Reminders System
**الملف الأساسي:** `lib/components/notification_helper.dart`

```dart
// فعّل التذكير
await NotificationHelper.scheduleDailyReminder(hour: 8, minute: 0);

// عطّل التذكير
await NotificationHelper.disableDailyReminder();

// تحقق من التفعيل
bool enabled = await NotificationHelper.isDailyReminderEnabled();

// الوقت الحالي
final (hour, minute) = await NotificationHelper.getReminderTime();

// اختبار فوري
await NotificationHelper.showTestNotification();
```

---

### Statistics & Usage Tracking
**الملفات:**
- `lib/components/usage_service.dart` - خدمة التتبع
- `lib/pages/statistics_page.dart` - عرض الإحصائيات
- `lib/providers/statistics_provider.dart` - إدارة البيانات

```dart
// تحميل البيانات
final dailySeconds = await UsageService.getDailySeconds();
final totalSeconds = await UsageService.getTotalSeconds();
final last7Days = await UsageService.getLastNDays(7);
final streak = await UsageService.getStreak();

// حفظ البيانات
await UsageService.saveDailySeconds(seconds);
await UsageService.saveTotalSeconds(seconds);
```

---

### Settings Page Components
**الملف الأساسي:** `lib/pages/settings.dart`

**الأقسام المتاحة:**
1. تخصيص المظهر - Font size, styles, dark mode
2. التنبيهات والتذكيرات - Daily reminder
3. إدارة البيانات - Reset, clear cache
4. حول التطبيق - Version, APK download
5. التواصل - Social media links

```dart
// الوصول إلى Theme Provider
final themeProvider = Provider.of<ThemeProvider>(context);

// تغيير حجم الخط
themeProvider.setFontSize(20.0);

// تغيير نمط الخط
themeProvider.setFontStyle(isBold: true, isItalic: false);
```

---

### Navigation & Bottom Nav Bar
**الملف الأساسي:** `lib/components/bottom_navigation_bar.dart`

```
Pages:
- 0: HomePage (الرئيسية)
- 1: FavoritePage (المفضلة)
- 2: StatisticsPage (الإحصائيات)
- 3: SettingsPage (الإعدادات)

Colors in Dark Mode:
- Selected: #00BFA5
- Unselected: #FFFFFF70
- Background: #1A2139
```

---

### Custom AppBar
**الملف:** `lib/components/custom_appbar.dart`

```dart
// الاستخدام البسيط
CustomAppBar(title: 'العنوان');

// مع بحث
CustomAppBar(
  title: 'العنوان',
  hasSearch: true,
  searchController: controller,
);

// القائمة المدرجة:
// - الإعدادات
// - الإحصائيات
```

---

### Sharable Hadith Card
**الملف:** `lib/components/sharable_hadith_card.dart`

```dart
ShareableHadithCard(hadith: hadithObject);

// الميزات:
// - تدرج لوني جميل
// - ظلال احترافية
// - عناصر زخرفية
// - يدعم Dark/Light Mode
```

---

## 🎨 Color Palette Reference

### Light Mode
```
Primary:       Color(0xFF00695C)
Background:    Colors.white
Surface:       Colors.white
Text:          Colors.black
```

### Dark Mode
```
Primary:       Color(0xFF00BFA5)
Background:    Color(0xFF0A0E27)
Surface:       Color(0xFF1A2139)
Text:          Colors.white
Text Secondary: Colors.white70
```

---

## 📦 Key Dependencies

```yaml
provider: ^6.0.0
shared_preferences: ^2.0.0
flutter_local_notifications: ^17.0.0
timezone: ^0.9.0
table_calendar: ^3.0.0
font_awesome_flutter: ^10.0.0
google_fonts: ^6.0.0
url_launcher: ^6.0.0
share_plus: ^7.0.0
```

---

## 🔧 Common Tasks

### Add a New Settings Option
```dart
_buildOptionTile(
  context,
  icon: Icons.icon_name,
  title: 'العنوان',
  subtitle: 'الوصف',
  onTap: () { /* action */ },
)
```

### Update Theme Colors
```dart
// في theme_provider.dart
final _darkMode = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF00BFA5),
    brightness: Brightness.dark,
  ),
  // ... باقي الإعدادات
);
```

### Schedule a Custom Notification
```dart
await _notificationsPlugin.zonedSchedule(
  id,
  'عنوان التنبيه',
  'محتوى التنبيه',
  scheduledDate,
  notificationDetails,
  // ... more parameters
);
```

---

## 🧪 Testing Checklist

- [ ] Dark Mode في جميع الصفحات
- [ ] Bottom Navigation مرئية وملونة
- [ ] التنبيهات تعمل
- [ ] الإحصائيات دقيقة
- [ ] الإعدادات تحفظ البيانات
- [ ] الروابط الاجتماعية تعمل
- [ ] لا توجد أخطاء في analyzer

---

## 🚀 Performance Tips

1. استخدم `Consumer<ThemeProvider>` بدلاً من `Provider.of` للأداء الأفضل
2. استخدم `ListView` مع `padding` بدلاً من `SingleChildScrollView` للقوائم الطويلة
3. استخدم `const` للعناصر الثابتة
4. تجنب الحسابات الثقيلة في `build()`

---

## 📱 Device-Specific Issues

### Android
- تأكد من تفعيل الإذن في `AndroidManifest.xml`
- استخدم `AndroidScheduleMode.inexactAllowWhileIdle` للموثوقية

### iOS
- استخدم `DarwinInitializationSettings`
- تحقق من إعدادات التنبيهات في الإعدادات

### Web (if supported)
- تجنب استخدام `timezone` و `workmanager`
- استخدم Web Notifications API بدلاً منها

---

## 🐛 Debugging Commands

```bash
# فحص التحليل
flutter analyze

# تنظيف البناء
flutter clean

# تثبيت المتطلبات
flutter pub get

# تشغيل مع Verbose
flutter run -v

# البناء للإصدار
flutter build apk --release
```

---

## 📚 Resources

- Flutter Docs: https://flutter.dev
- Material Design 3: https://m3.material.io
- Provider Package: https://pub.dev/packages/provider
- Table Calendar: https://pub.dev/packages/table_calendar

---

**آخر تحديث:** December 5, 2025  
**الإصدار:** 1.2.1  
**الحالة:** ✅ جاهز للإطلاق
