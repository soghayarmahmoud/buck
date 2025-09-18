import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Colors.grey.shade900,
      secondary: Colors.grey.shade700,
      onSurface: Colors.black,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      inversePrimary: Colors.grey.shade900,
      surface: Colors.white,
    ),
    cardColor: Colors.grey.shade300,
  );

  final _darkMode = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Colors.white,
      secondary: Colors.grey.shade600,
      onSurface: Colors.white,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      inversePrimary: Colors.grey.shade300,
      surface: Colors.grey.shade800,
    ),
    cardColor: Colors.grey.shade900,
  );
}
