import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  /// โหมดสว่าง/มืด (เปลี่ยนได้จากหน้า Setting)
  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.light);

  /// ฟอนต์ที่เลือก (null = ค่าเริ่มต้น) ต้องลงทะเบียนฟอนต์ใน pubspec.yaml ก่อน
  static final ValueNotifier<String?> fontFamily = ValueNotifier(null);

  static ThemeData build(Brightness brightness, String? font) {
    final dark = brightness == Brightness.dark;
    return ThemeData(
      brightness: brightness,
      fontFamily: font,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
      ),
      cardColor: dark ? const Color(0xFF24352B) : Colors.white,
      useMaterial3: true,
    );
  }
}