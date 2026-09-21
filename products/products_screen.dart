import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  final String title;
  const ProductsScreen({super.key, this.title = "ผลิตภัณฑ์ยา"});

  static const Color kGreenDark = Color(0xFF2E7D32);
  static const Color kGreenLight = Color(0xFFA8D8A8);
  static const Color kGreenBg = Color(0xFFDDEEDD);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 700;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          child: isDesktop
              ? _buildDesktopLayout(context)
              : _buildMobileLayout(context),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: _buildProfileCard(context)),
          const SizedBox(width: 40),
          Expanded(flex: 3, child: _buildInfoList(context)),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileCard(context),
          const SizedBox(height: 16),
          _buildInfoList(context),
        ],
      ),
    );
  }

  // ---- ส่วนหัวสีเขียว: ปุ่มย้อนกลับวงกลม + ชื่อหน้า ----
  // (เดิมเป็น "โปรไฟล์การ์ด" วงกลมไอคอน ตอนนี้ปรับเป็นเฮดเดอร์เขียวตามภาพ
  // แต่ยังคงใช้ชื่อฟังก์ชันเดิมเพื่อไม่ให้โครงสร้างเปลี่ยนมาก)
  Widget _buildProfileCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kGreenLight, kGreenBg],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Material(
            color: Colors.white,
            shape: const CircleBorder(),
            elevation: 3,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.of(context).maybePop(),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.arrow_back, color: kGreenDark),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kGreenDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---- รายการสินค้าแบบการ์ดแนวนอน (รูปซ้าย ข้อความขวา) ----
  Widget _buildInfoList(BuildContext context) {
    final products = [
      {
        "image": "assets/images/1.jpg",
        "title": "เชื้อไตรโคเดอร์มา",
        "price": "870 บาท",
        "description": "เชื้อราบิวเวอเรีย/ไตรโคเดอร์มาปลอดภัยสูง ช่วยยับยั้งเชื้อรา สาเหตุโรคพืชทางดิน เช่น โรครากเน่าโคนเน่า โรคเหี่ยว",
      },
      {
        "image": "assets/images/astrox88dpro.png",
        "title": "แมนโคเซบ",
        "price": "990 บาท",
        "description": "สารเคมีฤทธิ์สัมผัส ใช้ป้องกันและกำจัดโรคพืชที่เกิดจากเชื้อรา เช่น โรคราน้ำฝน โรคใบจุด โรคราแป้งและโรคแอนแทรคโนส",
      },
      {
        "image": "assets/images/astrox77dpro.png",
        "title": "คิวโทมอร์ฟ",
        "price": "1,190 บาท",
        "description": "ป้องกันกำจัดเชื้อราชนิดดูดซึม ออกฤทธิ์ยับยั้งการเจริญเติบโตและการสร้างสปอร์ของเชื้อรา โดยเฉพาะกลุ่ม",
      },
      {
        "image": "assets/images/shoes1.png",
        "title": "เรนเมน",
        "price": "2,065 บาท",
        "description": "สารป้องกันกำจัดเชื้อรากลุ่มใหม่ ออกฤทธิ์แบบดูดซึมและแทรกซึมผ่านใบ ยับยั้งการสร้างสปอร์และการเจริญเติบโตของเส้นใยเชื้อราได้อย่างมีประสิทธิภาพ ",
      },
    ];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kGreenBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12, left: 4),
            child: Text(
              "รายการสินค้า",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kGreenDark,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildProductCard(product);
            },
          ),
        ],
      ),
    );
  }

  // ---- การ์ดสินค้าเดี่ยว: รูปซ้าย + ชื่อ/รายละเอียด/ราคาขวา ----
  Widget _buildProductCard(Map<String, String> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 80,
              height: 80,
              child: Image.asset(
                product["image"]!,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product["title"]!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: kGreenDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product["description"]!,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                Text(
                  product["price"]!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
