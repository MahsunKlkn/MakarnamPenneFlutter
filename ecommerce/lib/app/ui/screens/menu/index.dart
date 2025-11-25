import 'package:flutter/material.dart';
import '../../../core/services/service_locator.dart';
import '../../../data/models/Product.dart';
import '../../../data/services/Product.dart';
import 'widgets/category_product_list.dart'; 

class MenuPage extends StatefulWidget {
  final int initialIndex;
  const MenuPage({super.key, this.initialIndex = 0});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  bool _isLoading = true;
  List<ProductModel> _makarnaList = [];
  List<ProductModel> _corbaList = [];
  List<ProductModel> _tatliList = [];
  List<ProductModel> _icecekList = [];
  List<ProductModel> _pilavList = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }
  Future<void> _fetchProducts() async {
    try {
      final productService = locator<ProductApiService>();
      final List<ProductModel> allProducts = await productService.getAllProducts();

      if (mounted) {
        setState(() {
          _makarnaList =
              allProducts.where((p) => p.categoryId == 1).toList();
          _corbaList = allProducts.where((p) => p.categoryId == 2).toList();
          _tatliList = allProducts.where((p) => p.categoryId == 3).toList();
          _icecekList = allProducts.where((p) => p.categoryId == 4).toList();
          _pilavList = allProducts.where((p) => p.categoryId == 5).toList();
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
    return DefaultTabController(
      initialIndex: widget.initialIndex,
      length: 5, 
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); 
            },
          ),
          title:
              const Text('Menü', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            tabAlignment: TabAlignment.start,
            labelPadding: const EdgeInsets.only(right: 16.0, left: 16.0),
            isScrollable: true,
            labelColor: Colors.deepOrange,
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: Colors.deepOrange,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Makarna'),
              Tab(text: 'Çorba'),
              Tab(text: 'Tatlı'),
              Tab(text: 'İçecek'),
              Tab(text: 'Pilav'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  CategoryProductList(items: _makarnaList),
                  CategoryProductList(items: _corbaList),
                  CategoryProductList(items: _tatliList),
                  CategoryProductList(items: _icecekList),
                  CategoryProductList(items: _pilavList),
                ],
              ),
      ),
    );
  }
}
