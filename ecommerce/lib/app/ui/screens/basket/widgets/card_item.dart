import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/services/Product.dart';
import '../../../../data/models/Product.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../viewmodels/auth_view_model.dart';
import '../../../../viewmodels/basket_view_model.dart';

class CartItem extends StatefulWidget {
  const CartItem({super.key});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late ProductApiService _productApiService;
  List<ProductModel> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _productApiService = locator<ProductApiService>();
    //_loadBaskets();

    WidgetsBinding.instance.addPostFrameCallback((_) {
    // 'mounted' kontrolü, widget'ın hala ekranda (ağaçta) olduğundan
    // emin olmak için iyi bir pratiktir.
    if (mounted) {
      _loadBaskets();
    }
  });
  }

  Future<void> _loadBaskets() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final basketViewModel = Provider.of<BasketViewModel>(context, listen: false);
    
    if (!authViewModel.isLoggedIn || authViewModel.currentUserId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    
    try {
      final userId = int.parse(authViewModel.currentUserId!);
      print('🛒 Kullanıcı ID $userId için sepet verileri getiriliyor...');
      
      // Sepeti yükle
      await basketViewModel.loadUserBasket(userId);
      
      if (basketViewModel.userBasket == null) {
        print('ℹ️ Kullanıcının sepeti boş');
        setState(() {
          isLoading = false;
        });
        return;
      }
      
      // Ürün ID'lerini al
      List<int> allProductIds = basketViewModel.userBasket!.getProductIdsList();
      print('🔍 Getirilecek ürün IDleri: $allProductIds');
      
      // Benzersiz ürün ID'lerini al
      Set<int> uniqueProductIds = allProductIds.toSet();
      print('🔍 Benzersiz ürün IDleri: $uniqueProductIds');
      
      // Her benzersiz ürün ID'si için ürün detaylarını getir
      List<ProductModel> fetchedProducts = [];
      for (int productId in uniqueProductIds) {
        try {
          print('📦 Ürün ID $productId getiriliyor...');
          final product = await _productApiService.getProductById(productId);
          if (product != null) {
            fetchedProducts.add(product);
            print('✅ Ürün getirildi: ${product.name} - ${product.price} TL');
          } else {
            print('❌ Ürün ID $productId için ürün bulunamadı');
          }
        } catch (e) {
          print('❌ Ürün ID $productId getirilirken hata: $e');
        }
      }
      
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
      
      print('🎉 Toplam ${fetchedProducts.length} benzersiz ürün başarıyla getirildi');
      
    } catch (e) {
      print('❌ Sepet verileri getirilirken hata: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (products.isEmpty) {
      return const Center(
        child: Text('Sepetinizde ürün bulunmuyor'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductItem(product);
      },
    );
  }

  Widget _buildProductItem(ProductModel product) {
    final basketViewModel = Provider.of<BasketViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    
    // Bu üründen sepette kaç adet var?
    int quantity = 0;
    if (basketViewModel.userBasket != null) {
      List<int> allProductIds = basketViewModel.userBasket!.getProductIdsList();
      quantity = allProductIds.where((id) => id == product.id).length;
    }
    
    // Fiyat hesaplamaları
    final double originalPrice = product.price;
    final double discountPercentage = product.discountRate ?? 0;
    final bool hasDiscount = discountPercentage > 0;
    final double discountedPrice = originalPrice * (1 - (discountPercentage / 100));
    
    // Toplam fiyatlar (adet × fiyat)
    final double totalOriginalPrice = originalPrice * quantity;
    final double totalDiscountedPrice = discountedPrice * quantity;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          product.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.restaurant_menu,
                                  color: Colors.orange[300], size: 40),
                        ),
                      )
                    : Icon(Icons.restaurant_menu,
                        color: Colors.orange[300], size: 40),
              ),
              const SizedBox(width: 16),
              // Ürün Detayları
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description ?? 'Açıklama yok',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Detay/Genişlet ikonu
              IconButton(
                icon: Icon(Icons.expand_more, color: Colors.grey[600]),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Kontroller ve Fiyat
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  // Azalt / Sil
                  InkWell(
                    onTap: () async {
                      if (!authViewModel.isLoggedIn || authViewModel.currentUserId == null) {
                        return;
                      }
                      
                      final userId = int.parse(authViewModel.currentUserId!);
                      
                      // Sepetten 1 adet çıkar
                      final success = await basketViewModel.removeProductFromBasket(userId, product.id);
                      
                      if (success) {
                        // Sepeti yeniden yükle
                        await _loadBaskets();
                        
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} sepetten çıkarıldı'),
                              duration: const Duration(seconds: 1),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.remove,
                          color: Colors.grey[700], size: 26),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Adet
                  Text('$quantity',
                      style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 20),
                  // Artır
                  InkWell(
                    onTap: () async {
                      if (!authViewModel.isLoggedIn || authViewModel.currentUserId == null) {
                        return;
                      }
                      
                      final userId = int.parse(authViewModel.currentUserId!);
                      
                      // Sepete 1 adet ekle
                      final success = await basketViewModel.addProductToBasket(userId, product.id);
                      
                      if (success) {
                        // Sepeti yeniden yükle
                        await _loadBaskets();
                        
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} sepete eklendi'),
                              duration: const Duration(seconds: 1),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 2,
                                offset: const Offset(0, 1))
                          ]),
                      child:
                          Icon(Icons.add, color: Colors.orange[700], size: 20),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (hasDiscount) ...[
                      Text(
                        '${totalOriginalPrice.toStringAsFixed(2)} TL',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                    Text(
                      '${totalDiscountedPrice.toStringAsFixed(2)} TL',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: hasDiscount ? Colors.deepOrange : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}