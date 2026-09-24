import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:project_flutter/services/authentication_service.dart';
import '../diagnosis/diagnosis_screen.dart';
import '../plants/field_crop_screen.dart' as field_crop;
import '../plants/garder_plants_screen.dart' as garden;
import '../plants/ornamental_plants_screen.dart' as ornamental;
import '../products/products_screen.dart';
import '../screens/auth/login_screen.dart';
import '../settings/setting_screen.dart';
import '../videos/videos_screen.dart';
import '../widgets/common_widgets.dart';
import '../models/plant_record_model.dart';
import '../services/database_helper.dart';
import 'plant_entry.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String title;

  const HomePage({
    super.key,
    this.username = 'username',
    this.title = 'หน้าหลัก',
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<plantRecordModel> plantItems = [];

  // ไปยังหน้าอื่น
  void _go(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  // ออกจากระบบ
  void _logout(BuildContext context) {
    AuthenticationService().logout().then((_) {
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _UserBar(username: widget.username),
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
                const SizedBox(height: 16),

                // ส่วนแสดงรายการประวัติบันทึกพืชจาก Database
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: DatabaseHelper().getStreamPlantRecords(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            'ไม่พบประวัติการบันทึกโรคพืช',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }
                      return _buildListView(snapshot);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3F5E4A),
        shape: const CircleBorder(),
        tooltip: 'เพิ่มประวัติการรักษาโรคพืช',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => plantEntry(
                action: 'add',
                plantRecord: plantRecordModel(
                  plantId: 'U001',
                  plantName: '0',
                  month: DateFormat('MMMM yyyy').format(DateTime.now()),
                  disease: '0',
                  treatmentProducts: '0',
                  paidStatus: 'Paid',
                ),
              ),
            ),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: _BottomBar(
        onVideos: () => _go(context, VideosScreen()),
        onProducts: () => _go(context, ProductsScreen()),
        onSettings: () => _go(context, SettingScreen()),
      ),
    );
  }

  // Build the ListView for displaying plant records
  Widget _buildListView(AsyncSnapshot<QuerySnapshot> snapshot) {
    plantItems.clear();
    for (var doc in snapshot.data!.docs) {
      plantItems.add(
        plantRecordModel(
          plantId: doc.get('plantId'),
          plantName: doc.get('plantName'),
          month: doc.get('month'),
          disease: doc.get('disease'),
          treatmentProducts: doc.get('treatmentProducts'),
          paidStatus: doc.get('paidStatus'),
          referenceId: doc.id,
        ),
      );
    }

    // เรียงลำดับข้อมูลตามเดือน
    plantItems.sort((a, b) {
      try {
        DateFormat format = DateFormat("MMMM yyyy");
        DateTime dateA = format.parse(a.month);
        DateTime dateB = format.parse(b.month);
        return dateA.compareTo(dateB);
      } catch (e) {
        return 0; // กรณี Format วันที่ใน DB ไม่ถูกต้อง
      }
    });

    return ListView.separated(
      itemCount: plantItems.length,
      itemBuilder: (BuildContext context, int index) {
        String titleDate = plantItems[index].month;
        String paidStatusText = plantItems[index].paidStatus == 'Paid'
            ? 'กำลังรักษา'
            : 'รักษาแล้ว';
        String subtitle =
            "โรค: ${plantItems[index].disease}\nผลิตภัณฑ์: ${plantItems[index].treatmentProducts}\n$paidStatusText";
        final item = plantItems[index];
        return Dismissible(
          key: ValueKey(item.referenceId),
          direction: DismissDirection.horizontal,
          // Swipe ซ้าย -> ขวา (startToEnd) : แก้ไข
          background: Container(
            color: Colors.blue,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.edit, color: Colors.white),
          ),
          // Swipe ขวา -> ซ้าย (endToStart) : ลบ
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              return await _handleDelete(item);
            } else if (direction == DismissDirection.startToEnd) {
              _handleEdit(item);
              // ไม่ต้องการให้ item หายไปจากลิสต์ แค่พาไปหน้าแก้ไขเท่านั้น
              return false;
            }
            return false;
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: Text(
                titleDate,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(subtitle, style: const TextStyle(fontSize: 14)),
              onTap: () {},
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 8);
      },
    );
  }

  // แสดง Dialog ยืนยัน Yes/No ก่อนลบ แล้วลบข้อมูลบน Cloud (Firestore)
  Future<bool> _handleDelete(plantRecordModel item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบข้อมูล'),
        content: Text('ต้องการลบรายการเดือน ${item.month} ใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return false;
    }

    try {
      // TODO: ปรับชื่อเมธอดให้ตรงกับ DatabaseHelper จริงของโปรเจกต์ หากไม่ใช่ deletePlantRecord
      await DatabaseHelper().deletePlantRecord(item.referenceId!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ลบประวัติการรักษาโรคพืชสำเร็จ'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      // ลบสำเร็จ -> Firestore stream จะอัปเดตรายการที่หน้า Home ให้อัตโนมัติ
      return true;
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ลบประวัติไม่สำเร็จ: $error'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return false;
    }
  }

  // พาไปหน้าฟอร์มแก้ไข พร้อมค่าเดิมของรายการที่เลือก
  void _handleEdit(plantRecordModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => plantEntry(
          action: 'edit',
          plantRecord: plantRecordModel(
            plantId: item.plantId,
            plantName: item.plantName,
            month: item.month,
            disease: item.disease,
            treatmentProducts: item.treatmentProducts,
            paidStatus: item.paidStatus,
            referenceId: item.referenceId,
          ),
        ),
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
              const _NavIcon(
                icon: Icons.home,
                tooltip: 'หน้าหลัก',
                selected: true,
              ),
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