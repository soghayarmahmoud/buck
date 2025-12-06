import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

// Modern material 3 themed provider with a seeded color scheme and dynamic customization.

class ThemeProvider extends ChangeNotifier {
  late ThemeData _themeData;
  double _fontSize = 18.0;

  // Color customization
  late Color _primaryColor;
  String _selectedColorScheme =
      'teal'; // teal, blue, purple, green, orange, red, pink

  // Font customization
  String _selectedFontFamily = 'cairo'; // cairo, tajawal, changa, droid, system

  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;

  ThemeProvider() {
    // Initializing with a default value to prevent the LateInitializationError
    _primaryColor = const Color(0xFF00695C);
    _themeData = _buildLightMode(_primaryColor, _selectedFontFamily);
    _loadSettings();
  }

  // Getters للوصول إلى البيانات
  ThemeData get themeData => _themeData;
  double get fontSize => _fontSize;
  bool get isDarkMode => _themeData.brightness == Brightness.dark;
  bool get isBold => _isBold;
  bool get isItalic => _isItalic;
  bool get isUnderline => _isUnderline;
  Color get primaryColor => _primaryColor;
  String get selectedColorScheme => _selectedColorScheme;
  String get selectedFontFamily => _selectedFontFamily;

  // تحميل الإعدادات من الذاكرة
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _fontSize = prefs.getDouble('fontSize') ?? 22.0;
    _isBold = prefs.getBool('isBold') ?? false;
    _isItalic = prefs.getBool('isItalic') ?? false;
    _isUnderline = prefs.getBool('isUnderline') ?? false;
    _selectedColorScheme = prefs.getString('colorScheme') ?? 'teal';
    _selectedFontFamily = prefs.getString('fontFamily') ?? 'cairo';
    _primaryColor = _getColorForScheme(_selectedColorScheme);
    _themeData = isDarkMode
        ? _buildDarkMode(_primaryColor, _selectedFontFamily)
        : _buildLightMode(_primaryColor, _selectedFontFamily);
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
    await prefs.setString('colorScheme', _selectedColorScheme);
    await prefs.setString('fontFamily', _selectedFontFamily);
  }

  // تغيير المظهر
  void toggleTheme() {
    _themeData = isDarkMode
        ? _buildLightMode(_primaryColor, _selectedFontFamily)
        : _buildDarkMode(_primaryColor, _selectedFontFamily);
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

  // تعيين لون المظهر
  void setColorScheme(String scheme) {
    _selectedColorScheme = scheme;
    _primaryColor = _getColorForScheme(scheme);
    _themeData = isDarkMode
        ? _buildDarkMode(_primaryColor, _selectedFontFamily)
        : _buildLightMode(_primaryColor, _selectedFontFamily);
    _saveSettings();
    notifyListeners();
  }

  // تعيين عائلة الخط
  void setFontFamily(String fontFamily) {
    _selectedFontFamily = fontFamily;
    _themeData = isDarkMode
        ? _buildDarkMode(_primaryColor, fontFamily)
        : _buildLightMode(_primaryColor, fontFamily);
    _saveSettings();
    notifyListeners();
  }

  // Get color for scheme
  Color _getColorForScheme(String scheme) {
    switch (scheme) {
      case 'blue':
        return const Color(0xFF1565C0);
      case 'purple':
        return const Color(0xFF7B1FA2);
      case 'green':
        return const Color(0xFF2E7D32);
      case 'orange':
        return const Color(0xFFE65100);
      case 'red':
        return const Color(0xFFC62828);
      case 'pink':
        return const Color(0xFFC2185B);
      case 'teal':
      default:
        return const Color(0xFF00695C);
    }
  }

  // Get font data for family
  TextStyle _getFontStyle(String fontFamily) {
    switch (fontFamily) {
      case 'tajawal':
        return GoogleFonts.tajawal();
      case 'changa':
        return GoogleFonts.changa();
      case 'droid':
        return GoogleFonts.cairo();
      case 'cairo':
      default:
        return GoogleFonts.cairo();
    }
  }

  // Build light theme with dynamic color and font
  ThemeData _buildLightMode(Color primaryColor, String fontFamily) {
    final baseTextStyle = _getFontStyle(fontFamily);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        titleTextStyle: baseTextStyle.copyWith(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: baseTextStyle.copyWith(fontSize: 16),
        bodyMedium: baseTextStyle.copyWith(fontSize: 14),
        titleLarge: baseTextStyle.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Build dark theme with dynamic color and font
  ThemeData _buildDarkMode(Color primaryColor, String fontFamily) {
    final baseTextStyle = _getFontStyle(fontFamily);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF0F1729),
      primaryColor: primaryColor,
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: const Color(0xFF1A2139),
        surfaceTintColor: primaryColor.withOpacity(0.05),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF1A2139),
        foregroundColor: Colors.white,
        titleTextStyle: baseTextStyle.copyWith(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: baseTextStyle.copyWith(fontSize: 16, color: Colors.white),
        bodyMedium: baseTextStyle.copyWith(fontSize: 14, color: Colors.white70),
        titleLarge: baseTextStyle.copyWith(
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
          borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
      ),
    );
  }
}
