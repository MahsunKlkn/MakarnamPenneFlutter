// lib/app/repository/CategoryRepository.dart

import 'dart:convert';
import '../data/models/Category.dart';
import '../data/services/base/BaseCategory.dart';

class CategoryRepository implements BaseCategoryApiService {
  /// Bu, Dio/Http kullanarak API ile konuşan asıl sınıf
  final BaseCategoryApiService _api;

  CategoryRepository(this._api);

  /// Tüm kategorileri C# API'den çeker ([HttpGet] /api/Category)
  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final result = await _api.getAllCategories();
      if (result is List) {
        final categories = <CategoryModel>[];
        for (var item in result) {
          try {
            if (item is Map<String, dynamic>) {
              categories.add(CategoryModel.fromJson(item));
            }
          } catch (e, stackTrace) {
            print(
              '❌ CATEGORY JSON PARSE HATASI (getAllCategories): ${jsonEncode(item)} -> Hata: $e',
            );
            print('Stack Trace: $stackTrace');
          }
        }
        print('📦 Repository - Toplam ${categories.length} kategori yüklendi.');
        return categories;
      }
      return []; // API'den liste gelmezse boş liste dön
    } catch (e, stackTrace) {
      print('❌ API HATASI (getAllCategories): $e');
      print('Stack Trace: $stackTrace');
      return [];
    }
  }

  /// ID'ye göre tek bir kategori çeker ([HttpGet] /api/Category/{id})
  @override
  Future<CategoryModel?> getCategoryById(int id) async {
    try {
      final result = await _api.getCategoryById(id);
      if (result is Map<String, dynamic>) {
        return CategoryModel.fromJson(result);
      }
      return null; // Beklenen format (Map) gelmezse
    } catch (e, stackTrace) {
      // API'den 404 Not Found hatası gelirse genellikle buraya düşer
      print('❌ API HATASI (getCategoryById $id): $e');
      print('Stack Trace: $stackTrace');
      return null;
    }
  }

  /// Yeni bir kategori ekler ([HttpPost] /api/Category)
  @override
  Future<bool> addCategory(CategoryModel category) async {
    try {
      // _api.addCategory metodu category.toJson() işlemini ve
      // http POST isteğini yapmalıdır.
      await _api.addCategory(category);
      print('📦 Repository - Kategori eklendi: ${category.name}');
      return true;
    } catch (e, stackTrace) {
      print('❌ API HATASI (addCategory): $e');
      print('Stack Trace: $stackTrace');
      return false;
    }
  }

  /// Mevcut bir kategoriyi günceller ([HttpPut] /api/Category/{id})
  @override
  Future<bool> updateCategory(int id, CategoryModel category) async {
    try {
      await _api.updateCategory(id, category);
      print('📦 Repository - Kategori güncellendi: (ID: $id) ${category.name}');
      return true;
    } catch (e, stackTrace) {
      print('❌ API HATASI (updateCategory $id): $e');
      print('Stack Trace: $stackTrace');
      return false;
    }
  }

  /// Bir kategoriyi siler ([HttpDelete] /api/Category/{id})
  @override
  Future<bool> deleteCategory(int id) async {
    try {
      await _api.deleteCategory(id);
      print('📦 Repository - Kategori silindi: (ID: $id)');
      return true;
    } catch (e, stackTrace) {
      print('❌ API HATASI (deleteCategory $id): $e');
      print('Stack Trace: $stackTrace');
      return false;
    }
  }
  
  /// Bir kategoriye ait tüm ürünleri getir (Controller'da olmayan ek bir fonksiyon)
  Future<List<dynamic>> getCategoryProducts(int categoryId) async {
    try {
      final result = await _api.getCategoryById(categoryId);
      if (result is Map<String, dynamic> && result.containsKey('products')) {
        return result['products'] as List<dynamic>;
      }
      return [];
    } catch (e, stackTrace) {
      print('❌ API HATASI (getCategoryProducts $categoryId): $e');
      print('Stack Trace: $stackTrace');
      return [];
    }
  }
}