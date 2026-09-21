import 'package:flutter/material.dart';

import '../models/disease.dart';
import '../products/products_screen.dart';
import '../videos/videos_screen.dart';
import '../widgets/common_widgets.dart';

class DiseaseDetailScreen extends StatelessWidget {
  final Disease disease;

  const DiseaseDetailScreen({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: disease.name,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          PlantImage(asset: disease.image, width: double.infinity, height: 180),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'พบใน ${disease.foundIn}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          InfoSection(
            title: 'อาการของโรค',
            icon: Icons.visibility,
            lines: [disease.symptoms],
          ),
          const SizedBox(height: 12),
          InfoSection(
            title: 'สาเหตุของโรค',
            icon: Icons.bug_report,
            lines: [disease.cause],
          ),
          const SizedBox(height: 12),
          InfoSection(
            title: 'วิธีการรักษา',
            icon: Icons.healing,
            lines: disease.treatment,
          ),
          const SizedBox(height: 12),
          InfoSection(
            title: 'การป้องกัน',
            icon: Icons.shield,
            lines: disease.prevention,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VideosScreen()),
                  ),
                  icon: const Icon(Icons.videocam),
                  label: const Text('ดูวิดีโอ'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF3F5E4A),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProductsScreen()),
                  ),
                  icon: const Icon(Icons.science),
                  label: const Text('ผลิตภัณฑ์'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}