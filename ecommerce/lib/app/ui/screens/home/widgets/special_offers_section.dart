import 'package:flutter/material.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../data/models/Product.dart';
import '../../../../data/services/Product.dart';
import 'product_card.dart';

class SpecialOffersSection extends StatefulWidget {
  const SpecialOffersSection({super.key});

  @override
  State<SpecialOffersSection> createState() => _SpecialOffersSectionState();
}

class _SpecialOffersSectionState extends State<SpecialOffersSection> {
  List<ProductModel> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      print('Ürünler getiriliyor...');
      final productService = locator<ProductApiService>();
      final List<ProductModel> allProducts = await productService
          .getAllProducts();
      print('API YANITI (Tüm Ürünler): $allProducts');
      if (mounted) {
        setState(() {
          _products = allProducts;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Ürün getirme hatası: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
          ? const Center(child: Text('Gösterilecek ürün bulunamadı.'))
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16.0),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                final double originalPrice = product.price;
                final double discountPercentage = product.discountRate ?? 0;
                final bool hasDiscount = discountPercentage > 0;
                final double discountedPrice =
                    originalPrice * (1 - (discountPercentage / 100));
                final String imagePath =
                    "lib/assets/images/${product.categoryId}.png";
                return ProductCard(
                  name: product.name,
                  price: discountedPrice.toStringAsFixed(2),
                  oldPrice: hasDiscount ? originalPrice.toStringAsFixed(2) : '',

                  imagePath: imagePath,
                );
              },
            ),
    );
  }
}
