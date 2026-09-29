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
  static const List<String> _fonts = [
    'Sarabun',
    'Kanit',
    'Prompt',
    'Mitr',
    'Athiti',
  ];

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();

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

          // --- ส่วนเลือก ฟอนต์ (Font) ---
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Font',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<String?>(
                  valueListenable: AppTheme.fontFamily,
                  builder: (context, currentFont, _) {
                    return Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        ChoiceChip(
                          label: const Text('ค่าเริ่มต้น'),
                          selected: currentFont == null,
                          onSelected: (_) {
                            AppTheme.fontFamily.value = null;
                          },
                        ),
                        for (final font in _fonts)
                          ChoiceChip(
                            label: Text(
                              font,
                              style: GoogleFonts.getFont(font, fontSize: 14),
                            ),
                            selected: currentFont == font,
                            onSelected: (selected) {
                              if (selected) {
                                AppTheme.fontFamily.value = font;
                              }
                            },
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // --- ส่วนสลับ Dark / Light Mode ---
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ValueListenableBuilder<ThemeMode>(
              valueListenable: AppTheme.mode,
              builder: (context, currentMode, _) {
                final isDark = currentMode == ThemeMode.dark;
                return SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Display Mode (Dark / Light)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  value: isDark,
                  onChanged: (value) {
                    AppTheme.mode.value =
                        value ? ThemeMode.dark : ThemeMode.light;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}