import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/disease.dart';
import '../widgets/common_widgets.dart';
import 'result_screen.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  final _picker = ImagePicker();
  XFile? _image;

  Future<void> _pick(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 85);
      if (picked != null) setState(() => _image = picked);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่สามารถเปิดกล้องหรือคลังภาพได้')),
      );
    }
  }

  void _analyze() {
    final image = _image;
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาถ่ายรูปหรือเลือกรูปก่อน')),
      );
      return;
    }

    // TODO: ส่งรูปไปยังโมเดล/API วินิจฉัยโรค แล้วนำผลจริงมาแทนตรงนี้
    // ตอนนี้ใช้โรคแรกในรายการเป็นผลลัพธ์ตัวอย่างเพื่อให้ทดสอบหน้าจอได้
    final result = fieldCropDiseases.first;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(imagePath: image.path, disease: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final image = _image;
    return AppPage(
      title: 'วินิจฉัยโรคพืช',
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 240,
              color: const Color(0xFFD9D9D9),
              alignment: Alignment.center,
              child: image == null
                  ? const Text(
                      'วางรูป\n(เลือกรูปจากอุปกรณ์)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    )
                  : SizedBox.expand(
                      child: kIsWeb
                          ? Image.network(image.path, fit: BoxFit.cover)
                          : Image.file(File(image.path), fit: BoxFit.cover),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF3F5E4A),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _pick(ImageSource.camera),
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('ถ่ายรูป'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF3F5E4A),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _pick(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('เลือกรูปภาพ'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const InfoSection(
            title: 'คำแนะนำ',
            icon: Icons.lightbulb,
            lines: [
              'ถ่ายให้เห็นส่วนที่เป็นโรคชัดเจน',
              'ถ่ายในที่ที่มีแสงสว่างเพียงพอ',
              'ถ่ายใกล้ ๆ ไม่ให้ภาพเบลอและไม่มีสิ่งบัง',
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.maybePop(context),
                  child: const Text('ยกเลิก'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF3F5E4A),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _analyze,
                  child: const Text('วิเคราะห์โรค'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}