// 'data/repositories/product_repository.dart' (Dosya yolu size bağlı)

import 'dart:convert';

import '../data/models/Product.dart';
import '../data/services/base/BaseProduct.dart';


class ProductRepository implements BaseProductApiService {
  /// Bu, Dio/Http kullanarak API ile konuşan asıl sınıf olmalı
  /// (örn: ProductApiProvider)
  final BaseProductApiService _api;

  ProductRepository(this._api);

  /// Tüm ürünleri C# API'den çeker ([HttpGet] /api/Product)
  /// Not: Bu metot, arayüzdeki `Future<dynamic>` metodunu "override" ederek
  /// daha spesifik bir tip olan `Future<List<ProductModel>>` döndürür.
  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final result = await _api.getAllProducts();
      if (result is List) {
        final products = <ProductModel>[];
        for (var item in result) {
          try {
            if (item is Map<String, dynamic>) {
              products.add(ProductModel.fromJson(item));
            }
          } catch (e, stackTrace) {
            print(
              '❌ PRODUCT JSON PARSE HATASI (getAllProducts): ${jsonEncode(item)} -> Hata: $e',
            );
            print('Stack Trace: $stackTrace');
          }
        }
        print('📦 Repository - Toplam ${products.length} ürün yüklendi.');
        return products;
      }
      return []; // API'den liste gelmezse boş liste dön
    } catch (e, stackTrace) {
      print('❌ API HATASI (getAllProducts): $e');
      print('Stack Trace: $stackTrace');
      return [];
    }
  }

  /// ID'ye göre tek bir ürün çeker ([HttpGet] /api/Product/{id})
  /// Not: `Future<dynamic>` yerine `Future<ProductModel?>` döndürür.
  @override
  Future<ProductModel?> getProductById(int id) async {
    try {
      final result = await _api.getProductById(id);
      if (result is Map<String, dynamic>) {
        return ProductModel.fromJson(result);
      }
      return null; // Beklenen format (Map) gelmezse
    } catch (e, stackTrace) {
      // API'den 404 Not Found hatası gelirse genellikle buraya düşer
      print('❌ API HATASI (getProductById $id): $e');
      print('Stack Trace: $stackTrace');
      return null;
    }
  }

  /// Yeni bir ürün ekler ([HttpPost] /api/Product)
  /// C# API'niz 'Ok("Ürün eklendi.")' döndüğü için, başarılı bir
  /// API çağrısı (2xx status code) sonrası 'true' dönmek yeterlidir.
  /// Not: `Future<dynamic>` yerine `Future<bool>` döndürür.
  @override
  Future<bool> addProduct(ProductModel product) async {
    try {
      // _api.addProduct metodu product.toJson() işlemini ve
      // http POST isteğini yapmalıdır.
      await _api.addProduct(product);
      print('📦 Repository - Ürün eklendi: ${product.name}');
      return true;
    } catch (e, stackTrace) {
      print('❌ API HATASI (addProduct): $e');
      print('Stack Trace: $stackTrace');
      return false;
    }
  }

  /// Mevcut bir ürünü günceller ([HttpPut] /api/Product/{id})
  /// Not: `Future<dynamic>` yerine `Future<bool>` döndürür.
  @override
  Future<bool> updateProduct(int id, ProductModel product) async {
    try {
      await _api.updateProduct(id, product);
      print('📦 Repository - Ürün güncellendi: (ID: $id) ${product.name}');
      return true;
    } catch (e, stackTrace) {
      print('❌ API HATASI (updateProduct $id): $e');
      print('Stack Trace: $stackTrace');
      return false;
    }
  }

  /// Bir ürünü siler ([HttpDelete] /api/Product/{id})
  /// Not: `Future<dynamic>` yerine `Future<bool>` döndürür.
  @override
  Future<bool> deleteProduct(int id) async {
    try {
      await _api.deleteProduct(id);
      print('📦 Repository - Ürün silindi: (ID: $id)');
      return true;
    } catch (e, stackTrace) {
      print('❌ API HATASI (deleteProduct $id): $e');
      print('Stack Trace: $stackTrace');
      return false;
    }
  }
}