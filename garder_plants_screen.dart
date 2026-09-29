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
      "โรครากเน่าโคนเน่า",
      "assets/images/g1.jpg",
      "พบใน ทุเรียน มะม่วง ส้ม และพืชผักบางชนิด",
    ),
    const Product(
      "โรคแคงเกอร์",
      "assets/images/g2.jpg",
      "พบใน มะนาว ส้ม และส้มโอ",
    ),
    const Product(
      "โรคเหี่ยวเขียว",
      "assets/images/g3.jpg",
      "พบใน พริก มะเขือ มันฝรั่ง กล้วย",
    ),
    const Product(
      "โรคราแป้ง",
      "assets/images/g4.jpg",
      "พบใน เงาะ มะม่วง องุ่น",
    ),
    const Product(
      "โรคใบด่างจากไวรัส",
      "assets/images/g5.jpg",
      "พบใน มะละกอ แตงกวา เมล่อน",
    ),
    const Product(
      "โรคเน่าเละ",
      "assets/images/g6.jpg",
      "พบใน กะหล่ำปลี ผักกาดขาว แครอท มันฝรั่ง",
    ),
    const Product(
      "โรคแอนแทรคโนส",
      "assets/images/g7.jpg",
      "พบใน มะม่วง มะละกอ พริก",
    ),
    const Product(
      "โรคราน้ำค้าง",
      "assets/images/g8.jpg",
      "พบใน แตงกวา แตงโม เมล่อน",
    ),
    const Product(
      "โรคใบจุดสีน้ำตาล",
      "assets/images/g9.jpg",
      "พบใน กล้วยไม้",
    ),
    const Product(
      "โรคกิ่งแห้ง",
      "assets/images/g10.jpg",
      "พบใน ทุเรียน ลำไย ลิ้นจี่",
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