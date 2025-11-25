import 'package:dio/dio.dart';
import '../../core/config/config.dart';
import 'base/BaseProduct.dart';
import '../models/Product.dart'; // Model'in doğru konumu

Future<void> _handleErrorWithPopup(DioException error) async {
  print("API Hatası: ${error.message ?? 'Bilinmeyen hata'}");
  print("DioException: $error");
  print("DioException Type: ${error.type}");
  if (error.response != null) {
    print("Endpoint: ${error.requestOptions.path}");
    print("Hata Detayı: ${error.response?.data}");
    print("Durum Kodu: ${error.response?.statusCode}");
  }
}

class ProductApiService implements BaseProductApiService {
  final Dio _dio;
  final String _serviceUrl;

  ProductApiService(this._dio)
      : _serviceUrl = '${AppConfig.instance.apiBaseUrl}/Product';
  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final response = await _dio.get(_serviceUrl);
      if (response.data is List) {
        return (response.data as List)
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Beklenmeyen API yanıtı formatı (List bekleniyordu)");
      }
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return [];
    }
  }

  /// ✅ ID'ye göre ürün getirir
  @override
  Future<ProductModel?> getProductById(int id) async {
    try {
      final response = await _dio.get('$_serviceUrl/$id');
      if (response.data is Map<String, dynamic>) {
        return ProductModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  /// ✅ Ürün ekler
  @override
  Future<ProductModel?> addProduct(ProductModel product) async {
    try {
      final response = await _dio.post(
        _serviceUrl,
        data: product.toJson(),
      );
      // Başarılı durumlarda backend JSON yerine metin dönebiliyor ("Ürün eklendi.")
      if ((response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 300) {
        if (response.data is Map<String, dynamic>) {
          return ProductModel.fromJson(response.data as Map<String, dynamic>);
        }
        // JSON değilse (String/plain text), en azından gönderdiğimiz ürünü başarı olarak döndür.
        return product;
      }
      return null;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  /// ✅ Ürün günceller
  @override
  Future<ProductModel?> updateProduct(int id, ProductModel product) async {
    try {
      final response = await _dio.put(
        '$_serviceUrl/$id',
        data: product.toJson(),
      );
      if ((response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 300) {
        if (response.data is Map<String, dynamic>) {
          return ProductModel.fromJson(response.data as Map<String, dynamic>);
        }
        // JSON değilse orijinal ürünü geri döndür (başarılı kabul et)
        return product;
      }
      return null;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  /// ✅ Ürün siler
  @override
  Future<bool> deleteProduct(int id) async {
    try {
      await _dio.delete('$_serviceUrl/$id');
      return true;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return false;
    }
  }

  /// ✅ Kategoriye göre ürünleri getirir
  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    try {
      final response = await _dio.get('$_serviceUrl/category/$categoryId');

      if (response.data is List) {
        return (response.data as List)
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Beklenmeyen API yanıtı formatı");
      }
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return [];
    }
  }
}
