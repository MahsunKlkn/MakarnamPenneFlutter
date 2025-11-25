// lib/features/menu/presentation/widgets/category_product_list.dart

import 'package:flutter/material.dart';
import '../../../../data/models/Product.dart';
import 'product_menu_card.dart'; // 💡 ProductMenuCard'ı buradan import ediyoruz

class CategoryProductList extends StatelessWidget {
  final List<ProductModel> items;

  const CategoryProductList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('Bu kategoride ürün bulunamadı.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ProductMenuCard(product: items[index]);
      },
    );
  }
}