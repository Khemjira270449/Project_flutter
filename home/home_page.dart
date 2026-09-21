import 'package:flutter/material.dart';

import '../diagnosis/diagnosis_screen.dart';
import '../plants/field_crop_screen.dart' as field_crop;
import '../plants/garder_plants_screen.dart' as garden;
import '../plants/ornamental_plants_screen.dart' as ornamental;
import '../products/products_screen.dart';
import '../settings/setting_screen.dart';
import '../videos/videos_screen.dart';
import '../widgets/common_widgets.dart';

class HomePage extends StatelessWidget {
  final String username;

  const HomePage({super.key, this.username = 'username'});

  // ไปยังหน้าอื่น
  void _go(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _UserBar(username: username),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _CategoryTab(
                        label: 'พืชไร่',
                        color: const Color(0xFF8FB89A),
                        onTap: () => _go(context, field_crop.CatalogPage()),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _CategoryTab(
                        label: 'พืชสวน',
                        color: const Color(0xFF7CCB94),
                        onTap: () => _go(context, garden.CatalogPage()),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _CategoryTab(
                        label: 'ไม้ดอก',
                        color: const Color(0xFFA5E3B5),
                        onTap: () => _go(context, ornamental.CatalogPage()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _DiagnosisCard(
                  onTap: () => _go(context, DiagnosisScreen()),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _BottomBar(
        onVideos: () => _go(context, VideosScreen()),
        onProducts: () => _go(context, ProductsScreen()),
        onSettings: () => _go(context, SettingScreen()),
      ),
    );
  }
}

class _UserBar extends StatelessWidget {
  final String username;
  const _UserBar({required this.username});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 14,
            backgroundColor: Color(0xFFE8A5AD),
          ),
          const SizedBox(width: 10),
          Text(
            username,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

class _DiagnosisCard extends StatelessWidget {
  final VoidCallback onTap;
  const _DiagnosisCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF3F5E4A),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.photo_camera, color: Color(0xFF3F5E4A)),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'วินิจฉัยโรคพืช',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'ถ่ายรูปหรือเลือกรูปเพื่อเริ่มตรวจ',
                      style: TextStyle(color: Color(0xFFD5EAD9), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final VoidCallback onVideos;
  final VoidCallback onProducts;
  final VoidCallback onSettings;

  const _BottomBar({
    required this.onVideos,
    required this.onProducts,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFD9D9D9),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const _NavIcon(icon: Icons.home, tooltip: 'หน้าหลัก', selected: true),
              _NavIcon(icon: Icons.videocam, tooltip: 'วิดีโอ', onTap: onVideos),
              _NavIcon(
                icon: Icons.science,
                tooltip: 'ผลิตภัณฑ์',
                onTap: onProducts,
              ),
              _NavIcon(
                icon: Icons.settings,
                tooltip: 'ตั้งค่า',
                onTap: onSettings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final bool selected;

  const _NavIcon({
    required this.icon,
    required this.tooltip,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkResponse(
        onTap: onTap,
        radius: 28,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF3F5E4A) : Colors.white,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: selected ? Colors.white : const Color(0xFF3F5E4A),
          ),
        ),
      ),
    );
  }
}