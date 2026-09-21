import 'package:flutter/material.dart';

import 'home/home_page.dart';
import 'theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: AppTheme.fontFamily,
      builder: (context, font, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: AppTheme.mode,
          builder: (context, mode, _) {
            return MaterialApp(
              title: 'Doctor Crop',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.build(Brightness.light, font),
              darkTheme: AppTheme.build(Brightness.dark, font),
              themeMode: mode,
              home: const HomePage(),
            );
          },
        );
      },
    );
  }
}