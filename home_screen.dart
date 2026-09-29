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
import '../theme/colors.dart';
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
        title: Text(
          widget.title,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.logout, color: AppColors.primary),
              onPressed: () => _logout(context),
            ),
          ),
        ],
      ),
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _UserBar(username: widget.username),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _CategoryTab(
                        label: 'พืชไร่',
                        icon: Icons.grass_rounded,
                        color: AppColors.primary,
                        onTap: () => _go(context, field_crop.CatalogPage()),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _CategoryTab(
                        label: 'พืชสวน',
                        icon: Icons.eco_rounded,
                        color: AppColors.primary.withOpacity(0.85),
                        onTap: () => _go(context, garden.CatalogPage()),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _CategoryTab(
                        label: 'ไม้ดอก',
                        icon: Icons.local_florist_rounded,
                        color: AppColors.primary.withOpacity(0.7),
                        onTap: () => _go(context, ornamental.CatalogPage()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _DiagnosisCard(
                  onTap: () => _go(context, DiagnosisScreen()),
                ),
                const SizedBox(height: 18),

                // หัวข้อประวัติ
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.history, size: 18, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        'ประวัติการรักษา',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // ส่วนแสดงรายการประวัติบันทึกพืชจาก Database
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: DatabaseHelper().getStreamPlantRecords(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.eco_outlined,
                                size: 40,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'ไม่พบประวัติการบันทึกโรคพืช',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
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
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.75),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
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
                    plantName: '',
                    month: DateFormat('MMMM yyyy').format(DateTime.now()),
                    disease: '',
                    treatmentProducts: '',
                    paidStatus: 'Paid',
                  ),
                ),
              ),
            );
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
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
      padding: const EdgeInsets.only(bottom: 90),
      itemCount: plantItems.length,
      itemBuilder: (BuildContext context, int index) {
        String titleDate = plantItems[index].month;
        bool isPaid = plantItems[index].paidStatus == 'Paid';
        String paidStatusText = isPaid ? 'กำลังรักษา' : 'รักษาแล้ว';
        final item = plantItems[index];
        return Dismissible(
          key: ValueKey(item.referenceId),
          direction: DismissDirection.horizontal,
          // Swipe ซ้าย -> ขวา (startToEnd) : แก้ไข
          background: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF4A90D9),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.edit, color: Colors.white),
          ),
          // Swipe ขวา -> ซ้าย (endToStart) : ลบ
          secondaryBackground: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE05C5C),
              borderRadius: BorderRadius.circular(14),
            ),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.eco_rounded, color: AppColors.primary),
              ),
              title: Text(
                titleDate,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'โรค: ${item.disease}\nผลิตภัณฑ์: ${item.treatmentProducts}',
                  style: const TextStyle(fontSize: 13, height: 1.3),
                ),
              ),
              isThreeLine: true,
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isPaid
                      ? Colors.orange.withOpacity(0.15)
                      : AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  paidStatusText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isPaid ? Colors.orange.shade800 : AppColors.primary,
                  ),
                ),
              ),
              onTap: () {},
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 10);
      },
    );
  }

  // แสดง Dialog ยืนยัน Yes/No ก่อนลบ แล้วลบข้อมูลบน Cloud (Firestore)
  Future<bool> _handleDelete(plantRecordModel item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('ยืนยันการลบข้อมูล'),
        content: Text('ต้องการลบรายการเดือน ${item.month} ใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes', style: TextStyle(color: AppColors.primary)),
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.7),
                ],
              ),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              username,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
          Icon(Icons.notifications_none, color: AppColors.primary),
        ],
      ),
    );
  }
}

class _CategoryTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _CategoryTab({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.35),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
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
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.75),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.photo_camera, color: AppColors.primary),
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
                      style: TextStyle(color: Color(0xFFE3F3E7), fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const _NavIcon(
                icon: Icons.home_rounded,
                tooltip: 'หน้าหลัก',
                selected: true,
              ),
              _NavIcon(
                icon: Icons.videocam_rounded,
                tooltip: 'วิดีโอ',
                onTap: onVideos,
              ),
              const SizedBox(width: 40), // เว้นที่ให้ FAB ตรงกลาง
              _NavIcon(
                icon: Icons.science_rounded,
                tooltip: 'ผลิตภัณฑ์',
                onTap: onProducts,
              ),
              _NavIcon(
                icon: Icons.settings_rounded,
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
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withOpacity(0.15)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: selected ? AppColors.primary : Colors.grey.shade500,
          ),
        ),
      ),
    );
  }
}