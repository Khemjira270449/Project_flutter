import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/theme.dart';
import '../widgets/common_widgets.dart';


class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // ต้องลงทะเบียนฟอนต์เหล่านี้ใน pubspec.yaml ถึงจะเห็นผลจริง
  static const _fonts = ['Sarabun', 'Kanit', 'Prompt', 'Mitr'];
  static const _keyFontSizeOption = 'fontSizeOption';
  static const _keyIsDarkMode = 'isDarkMode';

  static const String _defaultFont = 'Sarabun';
  static const double _defaultFontSize = 14.0;
  static const bool _defaultIsDarkMode = false;

  String _fontFamily = _defaultFont;
  double _fontSize = _defaultFontSize;
  bool _isDarkMode = _defaultIsDarkMode;
  
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  static const double _minFontSize = 14.0;
  static const double _maxFontSize = 20.0;

  String get fontFamily => _fontFamily;
  double get fontSize => _fontSize;
  bool get isDarkMode => _isDarkMode;


  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();

  String? _font = AppTheme.fontFamily.value;
  bool _dark = AppTheme.mode.value == ThemeMode.dark;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  Widget _field(String label, TextEditingController c, {TextInputType? type}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Theme.of(context).cardColor,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Setting',
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Color(0xFFE0E0E0),
              child: Icon(Icons.person, size: 56, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 20),
          _field('ชื่อ - นามสกุล', _name),
          _field('Email', _email, type: TextInputType.emailAddress),
          _field('เบอร์โทรศัพท์', _phone, type: TextInputType.phone),
          const SizedBox(height: 4),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Font', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    ChoiceChip(
                      label: const Text('ค่าเริ่มต้น'),
                      selected: _font == null,
                      onSelected: (_) {
                        setState(() => _font = null);
                        AppTheme.fontFamily.value = null;
                      },
                    ),
                    for (final f in _fonts)
                      ChoiceChip(
                        label: Text(f),
                        selected: _font == f,
                        onSelected: (_) {
                          setState(() => _font = f);
                          AppTheme.fontFamily.value = f;
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Display Mode (Dark / Light)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              value: _dark,
              onChanged: (v) {
                setState(() => _dark = v);
                AppTheme.mode.value = v ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ),
        ],
      ),
    );
  }
}