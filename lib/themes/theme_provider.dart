import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Modern material 3 themed provider with a seeded color scheme.

class ThemeProvider extends ChangeNotifier {
  late ThemeData _themeData;
  double _fontSize = 18.0;

  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;

  ThemeProvider() {
    // Initializing with a default value to prevent the LateInitializationError
    _themeData = _lightMode;
    _loadSettings();
  }

  // Getters للوصول إلى البيانات
  ThemeData get themeData => _themeData;
  double get fontSize => _fontSize;
  bool get isDarkMode => _themeData.brightness == Brightness.dark;
  bool get isBold => _isBold;
  bool get isItalic => _isItalic;
  bool get isUnderline => _isUnderline;

  // تحميل الإعدادات من الذاكرة
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _fontSize = prefs.getDouble('fontSize') ?? 22.0;
    _isBold = prefs.getBool('isBold') ?? false;
    _isItalic = prefs.getBool('isItalic') ?? false;
    _isUnderline = prefs.getBool('isUnderline') ?? false;

    _themeData = isDarkMode ? _darkMode : _lightMode;
    notifyListeners();
  }

  // حفظ جميع الإعدادات في الذاكرة
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
    await prefs.setDouble('fontSize', _fontSize);
    await prefs.setBool('isBold', _isBold);
    await prefs.setBool('isItalic', _isItalic);
    await prefs.setBool('isUnderline', _isUnderline);
  }

  // تغيير المظهر
  void toggleTheme() {
    _themeData = isDarkMode ? _lightMode : _darkMode;
    _saveSettings();
    notifyListeners();
  }

  // تعيين حجم الخط
  void setFontSize(double size) {
    _fontSize = size;
    _saveSettings();
    notifyListeners();
  }

  // تعيين أنماط الخط
  void setFontStyle({bool? isBold, bool? isItalic, bool? isUnderline}) {
    if (isBold != null) _isBold = isBold;
    if (isItalic != null) _isItalic = isItalic;
    if (isUnderline != null) _isUnderline = isUnderline;
    _saveSettings();
    notifyListeners();
  }

  final _lightMode = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF00695C), // teal seed
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
    ),
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
    ),
  );

  final _darkMode = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF00BFA5), // vibrant teal
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(
      0xFF0F1729,
    ), // deep purple-navy gradient aesthetic
    primaryColor: const Color(0xFF00BFA5),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF1A2139), // slightly lighter navy
      surfaceTintColor: const Color(0xFF00BFA5).withOpacity(0.05),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: const Color(0xFF1A2139),
      foregroundColor: Colors.white,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        backgroundColor: const Color(0xFF00BFA5),
        foregroundColor: Colors.white,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1A2139),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color(0xFF00BFA5).withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: const Color(0xFF00BFA5).withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF00BFA5), width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.white70),
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
    ),
  );
}
