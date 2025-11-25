// lib/app/data/services/Category.dart

import 'package:dio/dio.dart';
import '../../core/config/config.dart';
import 'base/BaseCategory.dart';
import '../models/Category.dart';

// Bu fonksiyon, hata durumlarını yönetmek için kullanılır
Future<void> _handleErrorWithPopup(DioException error) async {
  // Geliştirme aşamasında hatayı konsola yazdırmak faydalıdır.
  print("API Hatası: ${error.message}");
  print("DioException: ${error}");
  print("DioException Type: ${error.type}");
  if (error.response != null) {
    print("Endpoint: ${error.requestOptions.path}");
    print("Hata Detayı: ${error.response?.data}");
  }
}

class CategoryApiService implements BaseCategoryApiService {
  final Dio _dio;
  final String _serviceUrl;

  CategoryApiService(this._dio)
      : _serviceUrl = '${AppConfig.instance.apiBaseUrl}/Category';

  @override
  Future<dynamic> getAllCategories() async {
    try {
      final response = await _dio.get(_serviceUrl);
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> getCategoryById(int id) async {
    try {
      final response = await _dio.get('$_serviceUrl/$id');
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> addCategory(CategoryModel category) async {
    try {
      final response = await _dio.post(
        _serviceUrl,
        data: category.toJson(),
      );
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> updateCategory(int id, CategoryModel category) async {
    try {
      final response = await _dio.put(
        '$_serviceUrl/$id',
        data: category.toJson(),
      );
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> deleteCategory(int id) async {
    try {
      final response = await _dio.delete('$_serviceUrl/$id');
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }
  
  // Ek metot - kategoriye ait ürünleri getir
  Future<dynamic> getCategoryProducts(int categoryId) async {
    try {
      final response = await _dio.get('$_serviceUrl/$categoryId/products');
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }
}