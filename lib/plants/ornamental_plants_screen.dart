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
      "โรคราแป้ง",
      "assets/images/โรครากเน่าโคนเน่า.jpg",
      "พบใน กุหลาบ เบญจมาศ ดาวเรือง และพิทูเนีย",
    ),
    const Product(
      "โรคดอกเน่า/ราสีเทา",
      "assets/images/โรคดอกเน่า/ราสีเทา.jpg",
      "พบใน กล้วยไม้ ดาวเรือง และเยอบีร่า",
    ),
    const Product(
      "โรคใบด่างไวรัส",
     "assets/images/โรคใบด่างจากไวรัส.jpg",
      "พบใน กล้วยไม้ หน้าวัว และไม้ใบประดับ",
      
    ),
    const Product(
      "โรคราสนิม",
      "assets/images/โรคใบด่างจากไวรัส.jpg",
      "พบใน ลีลาวดี เบญจมาศ กุหลาบ กระบองเพชร ",
    ),
    const Product(
      "โรคโคนเน่าราเม็ดผักกาด",
      "assets/images/โรคเน่าเละ.jpg",
      "พบใน ดาวเรือง ปทุมมา กล้วยไม้ หน้าวัว",
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
