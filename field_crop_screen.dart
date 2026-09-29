import 'package:flutter/material.dart';

class Product {
  final String name;
  final String image;
  final String description;

  const Product(this.name, this.image, this.description);
}

class CatalogPage extends StatelessWidget {
  CatalogPage({super.key});

  final List<Product> products = [
    const Product(
      "โรคราน้ำค้าง",
      "assets/images/f1.png",
      "พบใน ข้าวโพด ข้าวฟ่าง เกิดจากเชื้อรา Peronosclerospora sorghi",
    ),
    const Product(
      "โรคใบขาว",
      "assets/images/f2.png",
      "พบใน อ้อย ข้าวโพด ข้าวฟ่าง เกิดจากเชื้อไฟโตพลาสมา",
    ),
    const Product(
      "โรคแส้ดำ",
      "assets/images/f3.png",
      "พบใน อ้อย เกิดจากเชื้อรา Sporisorium scitamineum",
    ),
    const Product(
      "โรคราแป้ง",
      "assets/images/f4.png",
      "พบใน ทานตะวัน ถั่วเหลือง",
    ),
    const Product(
      "โรคแอนแทรคโนส",
      "assets/images/f5.png",
      "พบใน ข้าวฟ่าง ถั่วเขียว อ้อย เกิดจากเชื้อรา Colletotrichum spp.",
    ),
    const Product(
      "โรคใบด่างมันสำปะหลัง",
      "assets/images/f6.png",
      "พบใน มันสำปะหลัง เกิดจากเชื้อไวรัส Cassava mosaic virus",
    ),
    const Product(
      "โรคเหี่ยวเน่าแดง",
      "assets/images/f7.png",
      "พบใน อ้อย เกิดจากเชื้อรา Colletotrichum falcatum ทำให้ลำต้นเน่าแดงและใบเหี่ยว",
    ),
    const Product(
      "โรคใบไหม้แผลใหญ่",
      "assets/images/f8.png",
      "พบใน ข้าวโพด ข้าวฟ่าง เกิดจากเชื้อรา Exserohilum turcicum",
    ),
    const Product(
      "โรคหัวเน่า",
      "assets/images/f9.png",
      "พบใน มันสำปะหลัง เกิดจากเชื้อราและแบคทีเรียในดินที่มีน้ำขังหรือระบายน้ำไม่ดี",
    ),
    const Product(
      "โรคราสนิม",
      "assets/images/f10.png",
      "พบใน ถั่วเหลือง ถั่วลิสง เกิดจากเชื้อรา Phakopsora pachyrhizi",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MY CATALOG"), centerTitle: true),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int count;

          if (constraints.maxWidth < 600) {
            count = 2;
          } else if (constraints.maxWidth < 900) {
            count = 3;
          } else {
            count = 4;
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: count,
              childAspectRatio: 0.65,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        products[index].image,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.image_not_supported, size: 40),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        products[index].name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        products[index].description,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}