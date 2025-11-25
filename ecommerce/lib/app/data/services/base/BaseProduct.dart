// 'data/services/base/base_product_api_service.dart'

import '../../../data/models/Product.dart'; // Doğru model konumu

abstract class BaseProductApiService {
  /// GET /api/Product - Tüm ürünleri getirir
  Future<dynamic> getAllProducts();

  /// GET /api/Product/{id} - ID'ye göre ürün detayı getirir
  Future<dynamic> getProductById(int id);

  /// POST /api/Product - Yeni ürün ekler
  Future<dynamic> addProduct(ProductModel product);

  /// PUT /api/Product/{id} - Ürünü günceller
  Future<dynamic> updateProduct(int id, ProductModel product);

  /// DELETE /api/Product/{id} - Ürünü siler
  Future<dynamic> deleteProduct(int id);
}