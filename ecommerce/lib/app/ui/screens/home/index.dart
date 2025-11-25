import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/home_header.dart';    
import 'widgets/home_search_bar.dart';
import 'widgets/hero_banner.dart';
import 'widgets/categories_section.dart';
import 'widgets/section_title.dart';
import 'widgets/special_offers_section.dart';
import 'widgets/flash_sales_section.dart';
import '../../../core/services/service_locator.dart';
import '../../../data/services/Product.dart';
import '../../../viewmodels/auth_view_model.dart';
import '../../../viewmodels/basket_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _loadUserBasket();
  }
  
  // Kullanıcı giriş yaptıysa sepetini yükle
  void _loadUserBasket() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final basketViewModel = Provider.of<BasketViewModel>(context, listen: false);
      
      if (authViewModel.isLoggedIn && authViewModel.currentUserId != null) {
        final userId = int.parse(authViewModel.currentUserId!);
        basketViewModel.loadUserBasket(userId);
      }
    });
  }

  Future<void> _fetchProducts() async {
    try {
      print('Ürünler getiriliyor...');
      final productService = locator<ProductApiService>();
      final response = await productService.getAllProducts();
      print('API YANITI (Tüm Ürünler):');
      print(response);
    } catch (e) {
      print('❌ Ürün getirme hatası: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HomeSearchBar(),
                    const HeroBanner(),
                    const CategoriesSection(),
                    const SectionTitle(title: "Size Özel Seçtiklerimiz"),
                    const SpecialOffersSection(),
                    const SectionTitle(title: "Flaş İndirimler"),
                    const FlashSalesSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}