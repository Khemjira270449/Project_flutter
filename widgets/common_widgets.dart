import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';

/// พื้นหลังไล่สีเขียวตามดีไซน์
class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: dark
              ? [AppColors.darkTop, AppColors.darkBottom]
              : [AppColors.lightTop, AppColors.lightBottom],
        ),
      ),
      child: child,
    );
  }
}

/// ปุ่มย้อนกลับ + ชื่อหน้า
class AppHeader extends StatelessWidget {
  final String title;
  const AppHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: Theme.of(context).cardColor,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.maybePop(context),
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.arrow_back),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

/// โครงหน้าทั่วไป: พื้นหลัง + header + เนื้อหา
class AppPage extends StatelessWidget {
  final String title;
  final Widget child;
  const AppPage({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppHeader(title: title),
                const SizedBox(height: 16),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// การ์ดสีขาว (สีตามธีม)
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// รูปพืช/โรค ถ้ายังไม่มีรูปหรือโหลดไม่ได้จะแสดงกรอบสีเขียวแทน
class PlantImage extends StatelessWidget {
  final String? asset;
  final double? width;
  final double? height;
  final IconData icon;

  const PlantImage({
    super.key,
    this.asset,
    this.width,
    this.height,
    this.icon = Icons.eco,
  });

  Widget get _fallback => Container(
        color: AppColors.placeholder,
        child: Center(child: Icon(icon, size: 40, color: AppColors.primary)),
      );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: width,
        height: height,
        child: asset == null
            ? _fallback
            : Image.asset(
                asset!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallback,
              ),
      ),
    );
  }
}

/// การ์ดหัวข้อ + เนื้อหา (อาการ, สาเหตุ, วิธีรักษา ฯลฯ)
class InfoSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<String> lines;

  const InfoSection({
    super.key,
    required this.title,
    required this.icon,
    required this.lines,
  });

  @override
  Widget build(BuildContext context) {
    final bullet = lines.length > 1;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(bullet ? '• $line' : line, style: const TextStyle(height: 1.4)),
            ),
        ],
      ),
    );
  }
}

/// ส่วนหัวโค้งมนไล่สีเขียว มีไอคอนวงกลมลอยอยู่ตรงกลาง
class LeafHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const LeafHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.eco_rounded,
  });

  @override
  Widget build(BuildContext context) {
    const base = AppColors.primary;
    final hsl = HSLColor.fromColor(base);
    final darker =
        hsl.withLightness((hsl.lightness - 0.18).clamp(0.0, 1.0)).toColor();

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(48),
        bottomRight: Radius.circular(48),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [darker, base],
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -30,
              right: -30,
              child: _softCircle(120, const Color.fromRGBO(255, 255, 255, 0.06)),
            ),
            Positioned(
              bottom: 60,
              left: -40,
              child: _softCircle(90, const Color.fromRGBO(255, 255, 255, 0.05)),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 64),
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: darker, size: 36),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: GoogleFonts.kanit(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.sarabun(
                        fontSize: 14,
                        color: const Color.fromRGBO(255, 255, 255, 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _softCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}