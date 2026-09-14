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
      "assets/images/Field-ราน้ำค้าง.jpg",
      "พบใน แตงกวา มะเขือเทศ พริก และพืชตระกูลแตงบางชนิด",
    ),
    const Product(
      "โรคใบขาว",
      "assets/images/Field-ใบขาว.jpg",
      "พบใน อ้อย ข้าวโพด ข้าวสาลี",
    ),
    const Product(
      "โรคแส้ดำ",
     "assets/images/Field-แส้ดำ.jpg",
      "พบใน อ้อย"),

    const Product(
      "โรคราแป้ง",
      "assets/images/Field-ราแป้ง.jpg",
      "พบใน ทานตะวัน, ถั่วเหลือง",
    ),
    const Product(
      "โรคแอนแทรคโนส",
      "assets/images/Field-แอนแทรคโนส.jpg",
      "พบใน มะม่วง ข้าวโพด อ้อย พืชตะกูลถั่ว",
    ),
    const Product(
      "โรคใบด่างมันสำปะหลัง",
      "assets/images/Field-ใบด่างมันสำปะหลัง.jpg",
      "พบใน ข้าวโพด มันสำปะหลัง",
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
