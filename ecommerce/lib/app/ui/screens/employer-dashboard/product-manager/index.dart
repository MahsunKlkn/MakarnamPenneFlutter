import 'package:flutter/material.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../data/models/Product.dart';
import '../../../../data/services/Product.dart';
import '../../../../data/models/Category.dart';
import 'widgets/product_form_dialog.dart';

class ProductManagerPage extends StatefulWidget {
  const ProductManagerPage({super.key});

  @override
  State<ProductManagerPage> createState() => _ProductManagerPageState();
}

class _ProductManagerPageState extends State<ProductManagerPage>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  List<ProductModel> _makarnaList = [];
  List<ProductModel> _corbaList = [];
  List<ProductModel> _tatliList = [];
  List<ProductModel> _icecekList = [];
  List<ProductModel> _pilavList = [];

  late TabController _tabController;

  final Map<int, String> categoryIdToName = {
    1: "Makarna",
    2: "Çorba",
    3: "Tatlı",
    4: "İçecek",
    5: "Pilav",
  };

  List<CategoryModel> _categoryList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    _populateCategoryList();

    // Ürünleri API'den çek
    _fetchProducts();
  }

  void _populateCategoryList() {
    final now = DateTime.now();

    _categoryList = categoryIdToName.entries.map((entry) {
      return CategoryModel(
        id: entry.key,
        name: entry.value,

        dateCreated: now,
        dateUpdated: now,
      );
    }).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    try {
      final productService = locator<ProductApiService>();
      final List<ProductModel> allProducts = await productService
          .getAllProducts();

      if (mounted) {
        setState(() {
          _makarnaList = allProducts.where((p) => p.categoryId == 1).toList();
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ürünler yüklenirken bir hata oluştu: $e')),
        );
      }
    }
  }

  List<ProductModel> _getListForCategory(int categoryId) {
    switch (categoryId) {
      case 1:
        return _makarnaList;
      case 2:
        return _corbaList;
      case 3:
        return _tatliList;
      case 4:
        return _icecekList;
      case 5:
        return _pilavList;
      default:
        return [];
    }
  }

  void _showProductForm({ProductModel? product}) {
    int initialCategoryId = product?.categoryId ?? (_tabController.index + 1);

    if (!_categoryList.any((c) => c.id == initialCategoryId)) {
      initialCategoryId = _categoryList.first.id;
    }
    ProductModel? formProduct = product;
    if (formProduct == null) {
      final now = DateTime.now();
      
      formProduct = ProductModel(
        id: 0,
        name: '',
        price: 0.0,
        categoryId: initialCategoryId,
        stockQuantity: 0,
        isActive: true,
        dateCreated: now,
        dateUpdated: now,
        description: null,
        discountRate: 0,
        sku: null,
        imageUrl: null,
      );
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ProductFormDialog(
          product: formProduct,
          categories: _categoryList,
          onSave: (savedProduct) {
            _handleSaveProduct(savedProduct);
          },
        );
      },
    );
  }

  // index.dart

 // index.dart

  Future<void> _handleSaveProduct(ProductModel product) async {
    final bool isCreating = (product.id == 0);

    // 'context'i ve 'scaffoldMessenger'ı await'ten ÖNCE yakala
    // Bu, 'context'i asenkron işlemler arasında kaybetmemizi engeller.
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final productService = locator<ProductApiService>();
      ProductModel? savedProduct;

      if (isCreating) {
        // === YENİ ÜRÜN EKLEME - VERİTABANINA KAYDET ===
        print("🚀 YENİ ÜRÜN OLUŞTURULUYOR...");
        savedProduct = await productService.addProduct(product); // <-- AWAIT 1
        
        if (savedProduct != null) {
          if ((savedProduct.id) == 0) {
            await _fetchProducts(); // <-- AWAIT 2
          } else {
            // await olmadığı için 'mounted' kontrolü gerekmez
            setState(() { 
              _getListForCategory(savedProduct!.categoryId).add(savedProduct);
            });
          }

          // ******** DÜZELTME BURADA ********
          // 'await' işlemlerinden sonra 'mounted' kontrolü EKLENDİ.
          if (mounted) { 
            scaffoldMessenger.showSnackBar( // 'scaffoldMessenger' değişkenini kullan
              SnackBar(content: Text('${savedProduct.name} başarıyla eklendi!')),
            );
          }
          // ******** DÜZELTME BİTTİ ********

        } else {
          throw Exception('Ürün eklenirken API yanıt vermedi');
        }
      } else {
        // === ÜRÜN GÜNCELLEME - VERİTABANINDA GÜNCELLE ===
        print("🔄 ${product.name} GÜNCELLENİYOR...");

        savedProduct = await productService.updateProduct(product.id, product); // <-- AWAIT 1

        if (savedProduct != null) {
          await _fetchProducts(); // <-- AWAIT 2

          if (mounted) { // Bu kısım zaten doğruydu
            scaffoldMessenger.showSnackBar( // 'scaffoldMessenger' değişkenini kullan
              SnackBar(
                content: Text('${savedProduct.name} başarıyla güncellendi!'),
              ),
            );
          }
        } else {
          if (mounted) { // Bu kısım zaten doğruydu
            scaffoldMessenger.showSnackBar( // 'scaffoldMessenger' değişkenini kullan
              SnackBar(content: Text('Ürün güncellenemedi. API hatası.')),
            );
          }
        }
      }
    } catch (e) {
      print('❌ Kaydetme hatası: $e');
      if (mounted) { // Bu kısım zaten doğruydu
        scaffoldMessenger.showSnackBar( // 'scaffoldMessenger' değişkenini kullan
          SnackBar(content: Text('Ürün kaydedilirken bir hata oluştu: $e')),
        );
      }
    }
  }

  // index.dart

  void _showDeleteConfirmDialog(ProductModel product) {
    // Bu 'context', sayfanın (_ProductManagerPageState) context'idir.
    showDialog(
      context: context,
      // Builder'ın kendi context'ine 'dialogContext' adını veriyoruz.
      builder: (BuildContext dialogContext) { 
        return AlertDialog(
          title: const Text('Ürünü Sil'),
          content: Text(
            '\'${product.name}\' adlı ürünü silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
          ),
          actions: [
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                // Diyaloğu kapatmak için 'dialogContext' kullanılır.
                Navigator.of(dialogContext).pop(); 
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Sil'),
              onPressed: () async {
                // Onay diyaloğunu kapatmak için 'dialogContext' kullanılır.
                Navigator.of(dialogContext).pop(); 
                
                // Yüklenme göstergesini göstermek için sayfanın 'context'i kullanılır.
                showDialog(
                  context: context, // <-- DÜZELTME BURADA
                  barrierDismissible: false,
                  builder: (BuildContext context) { // Bu, yüklenme diyaloğunun context'i
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                try {
                  final productService = locator<ProductApiService>();
                  
                  final bool isDeleted = await productService.deleteProduct(product.id);
                  
                  // 'await' işleminden sonra 'mounted' kontrolü ZORUNLUDUR.
                  if (mounted) { 
                    // Yüklenme diyaloğunu kapatmak için sayfanın 'context'i kullanılır.
                    Navigator.of(context).pop(); 
                    
                    if (isDeleted) {
                      setState(() {
                        _getListForCategory(product.categoryId).remove(product);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product.name} silindi!')),
                      );
                    } else {
                      throw Exception('Ürün silinemedi');
                    }
                  }
                } catch (e) {
                  print('❌ Silme hatası: $e');
                  // 'await' işleminden sonra 'mounted' kontrolü ZORUNLUDUR.
                  if (mounted) { 
                    // Yüklenme diyaloğunu kapatmak için sayfanın 'context'i kullanılır.
                    Navigator.of(context).pop(); 
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Ürün silinirken bir hata oluştu: $e'),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductList(List<ProductModel> productList) {
    if (productList.isEmpty) {
      return const Center(child: Text('Bu kategoride yönetilecek ürün yok.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      itemCount: productList.length,
      itemBuilder: (context, index) {
        final product = productList[index];
        final String imagePath = "lib/assets/images/${product.categoryId}.png";

        // Fiyat hesaplama mantığı
        final double originalPrice = product.price;
        final double discountPercentage = product.discountRate ?? 0;
        final bool hasDiscount = discountPercentage > 0;
        final double discountedPrice =
            originalPrice * (1 - (discountPercentage / 100));

        return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        OutlinedButton.icon(
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Düzenle'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.indigo, // Mor-lacivert
                            side: const BorderSide(color: Colors.indigo),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            _showProductForm(product: product);
                          },
                        ),
                        const SizedBox(width: 8),

                        // Sil Butonu
                        OutlinedButton.icon(
                          icon: const Icon(Icons.delete, size: 18),
                          label: const Text('Sil'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            side: const BorderSide(color: Colors.redAccent),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            _showDeleteConfirmDialog(product);
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 24.0, thickness: 0.5),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
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
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text(
          'Ürün Yöneticisi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showProductForm(product: null);
        },
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildProductList(_makarnaList),
                _buildProductList(_corbaList),
                _buildProductList(_tatliList),
                _buildProductList(_icecekList),
                _buildProductList(_pilavList),
              ],
            ),
    );
  }
}
