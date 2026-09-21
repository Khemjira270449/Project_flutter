import 'package:flutter/material.dart';

import '../models/disease.dart';
import '../widgets/common_widgets.dart';

class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'วิดีโอการรักษาโรคพืช',
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: allDiseases.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final d = allDiseases[i];
          return AppCard(
            onTap: () {
              // TODO: เปิดวิดีโอจริง (เช่น ใช้แพ็กเกจ video_player หรือ url_launcher)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('ยังไม่ได้เชื่อมวิดีโอของ${d.name}')),
              );
            },
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    PlantImage(asset: d.image, width: 110, height: 70),
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.black54,
                      child: Icon(Icons.play_arrow, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'วิธีรักษา${d.name}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text('พบใน ${d.foundIn}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}