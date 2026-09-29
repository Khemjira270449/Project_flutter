import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.light);
  static final ValueNotifier<String?> fontFamily = ValueNotifier('Prompt');

  /// Getter สำหรับเรียกใช้ธีม Light และ Dark ได้สะดวก
  static ThemeData get light => build(Brightness.light, fontFamily.value);
  static ThemeData get dark => build(Brightness.dark, fontFamily.value);

  static ThemeData build(Brightness brightness, String? font) {
    final isDark = brightness == Brightness.dark;

    var themeData = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      cardColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
    );

    // ประยุกต์ใช้ Google Fonts พร้อมปรับสีตัวหนังสือให้เข้ากับ Brightness
    if (font != null && font.isNotEmpty) {
      final baseTextTheme = themeData.textTheme;
      themeData = themeData.copyWith(
        textTheme: GoogleFonts.getTextTheme(font, baseTextTheme).apply(
          bodyColor: isDark ? Colors.white : Colors.black87,
          displayColor: isDark ? Colors.white : Colors.black87,
        ),
      );
    }

    return themeData;
  }
}