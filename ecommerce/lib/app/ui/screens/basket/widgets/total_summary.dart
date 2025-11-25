import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../data/services/Product.dart';
import '../../../../data/models/Product.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../viewmodels/auth_view_model.dart';
import '../../../../viewmodels/basket_view_model.dart';

class TotalSummary extends StatefulWidget {
  const TotalSummary({super.key});

  @override
  State<TotalSummary> createState() => _TotalSummaryState();
}

class _TotalSummaryState extends State<TotalSummary> {
  late ProductApiService _productApiService;
  List<ProductModel> products = [];
  bool isLoading = true;
  double totalPrice = 0.0; // İndirimli toplam
  double originalTotalPrice = 0.0; // Orijinal toplam
  int totalItems = 0;
  String? _lastBasketProductIds; // Son yüklenen sepet ürünlerini takip et

  @override
  void initState() {
    super.initState();
    _productApiService = locator<ProductApiService>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) {
      _loadBasketSummary();
    }
  });
  }

  Future<void> _loadBasketSummary() async {
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
      print('💰 Sepet özeti hesaplanıyor...');
      
      // Sepeti yükle
      await basketViewModel.loadUserBasket(userId);
      
      if (basketViewModel.userBasket == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Tüm ürün ID'lerini topla
      List<int> allProductIds = basketViewModel.userBasket!.getProductIdsList();

      // Her ürün için detayları getir
      List<ProductModel> fetchedProducts = [];
      double originalTotal = 0.0;
      double discountedTotal = 0.0;

      for (int productId in allProductIds) {
  try {
    final product = await _productApiService.getProductById(productId);
    if (product != null) {
      fetchedProducts.add(product);

      double price = product.price;
      // 100 üzerinden gelen indirim oranını normalize et
      double discountRate = ((product.discountRate ?? 0) / 100).clamp(0.0, 1.0);
      double finalPrice = price * (1 - discountRate);

      originalTotal += price;
      discountedTotal += finalPrice;

      print(
        '🛍️ ${product.name}: ${price.toStringAsFixed(2)} TL → ${finalPrice.toStringAsFixed(2)} TL (%${(discountRate * 100).toInt()})',
      );
    }
  } catch (e) {
    print('❌ Ürün ID $productId getirilirken hata: $e');
  }
}



      setState(() {
        products = fetchedProducts;
        totalItems = fetchedProducts.length;
        totalPrice = discountedTotal;
        originalTotalPrice = originalTotal;
        isLoading = false;
      });

      print('💰 Sepet Özeti:');
      print(' - Ürün Sayısı: $totalItems');
      print(' - Orijinal Toplam: ${originalTotal.toStringAsFixed(2)} TL');
      print(' - İndirimli Toplam: ${discountedTotal.toStringAsFixed(2)} TL');
    } catch (e) {
      print('❌ Sepet özeti hesaplanırken hata: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // BasketViewModel'i dinle - sepet her değiştiğinde yeniden hesapla
    final basketViewModel = Provider.of<BasketViewModel>(context);
    
    // Sepet değişip değişmediğini kontrol et (sonsuz döngüden kaçın)
    final currentBasketProductIds = basketViewModel.userBasket?.productIds;
    if (!isLoading && 
        currentBasketProductIds != null && 
        currentBasketProductIds != _lastBasketProductIds) {
      _lastBasketProductIds = currentBasketProductIds;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _loadBasketSummary();
        }
      });
    }
    
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    bool hasDiscount = (originalTotalPrice - totalPrice) > 0.01;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Toplam ($totalItems ürün)',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(
                '(Ücretler ve vergi dahil)',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: _showBasketDetails,
                child: Text(
                  'Detaylar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange[700],
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (hasDiscount) ...[
                Text(
                  '${originalTotalPrice.toStringAsFixed(2)} TL',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(height: 4),
              ],
              Text(
                '${totalPrice.toStringAsFixed(2)} TL',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.orange[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBasketDetails() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Sepet Detayları',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...products.map((product) {
                double discountRate = product.discountRate ?? 0.0;
                double finalPrice = product.price * (1 - discountRate);
                bool hasProductDiscount = discountRate > 0;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(fontSize: 14),
                            ),
                            if (hasProductDiscount)
                              Text(
                                '%${(discountRate * 100).toInt()} indirim',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (hasProductDiscount) ...[
                            Text(
                              '${product.price.toStringAsFixed(2)} TL',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(height: 2),
                          ],
                          Text(
                            '${finalPrice.toStringAsFixed(2)} TL',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: hasProductDiscount
                                  ? Colors.green[600]
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
              const Divider(),
              if ((originalTotalPrice - totalPrice) > 0.01) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Ara Toplam:',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      '${originalTotalPrice.toStringAsFixed(2)} TL',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Toplam İndirim:',
                      style:
                          TextStyle(fontSize: 14, color: Colors.green[600]),
                    ),
                    Text(
                      '-${(originalTotalPrice - totalPrice).toStringAsFixed(2)} TL',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ödenecek Tutar:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${totalPrice.toStringAsFixed(2)} TL',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
