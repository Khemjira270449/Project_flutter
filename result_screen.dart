import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../models/disease.dart';
import '../products/products_screen.dart';
import '../widgets/common_widgets.dart';
import 'disease_detail_screen.dart';

class ResultScreen extends StatelessWidget {
  final String imagePath;
  final Disease disease;

  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.disease,
  });

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'ผลการวินิจฉัยโรค',
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 220,
              width: double.infinity,
              child: kIsWeb
                  ? Image.network(imagePath, fit: BoxFit.cover)
                  : Image.file(File(imagePath), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              disease.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              'พบใน ${disease.foundIn}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProductsScreen()),
                  ),
                  child: const Text('ดูผลิตภัณฑ์'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF3F5E4A),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DiseaseDetailScreen(disease: disease),
                    ),
                  ),
                  child: const Text('ดูวิธีรักษา'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}