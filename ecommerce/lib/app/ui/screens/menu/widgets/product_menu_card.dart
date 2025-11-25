import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/models/Product.dart';
import '../../../../viewmodels/auth_view_model.dart';
import '../../../../viewmodels/basket_view_model.dart';

class ProductMenuCard extends StatelessWidget {
  final ProductModel product;

  const ProductMenuCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final double originalPrice = product.price;
    final double discountPercentage = product.discountRate ?? 0;
    final bool hasDiscount = discountPercentage > 0;
    final double discountedPrice =
        originalPrice * (1 - (discountPercentage / 100));
    final String imagePath = "lib/assets/images/${product.categoryId}.png";

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8.0, 16.0, 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name, 
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${discountedPrice.toStringAsFixed(2)} TL', 
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (hasDiscount)
                        Text(
                          '${originalPrice.toStringAsFixed(2)} TL',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description ?? "Açıklama bulunmuyor.", 
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              clipBehavior: Clip.none, 
              children: [
                
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    imagePath, 
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[200],
                      child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -8,
                  right: -8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.deepOrange),
                      onPressed: () async {
                        final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
                        final basketViewModel = Provider.of<BasketViewModel>(context, listen: false);
                        
                        // Kullanıcı giriş yapmış mı kontrol et
                        if (!authViewModel.isLoggedIn || authViewModel.currentUserId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sepete ürün eklemek için giriş yapmalısınız!'),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        
                        final userId = int.parse(authViewModel.currentUserId!);
                        
                        // Sepete ürün ekle
                        final success = await basketViewModel.addProductToBasket(userId, product.id);
                        
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} sepete eklendi!'),
                              duration: const Duration(seconds: 1),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(basketViewModel.errorMessage ?? 'Bir hata oluştu'),
                              duration: const Duration(seconds: 2),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      },
                    ),
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