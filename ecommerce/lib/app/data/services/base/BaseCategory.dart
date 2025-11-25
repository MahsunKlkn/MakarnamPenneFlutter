// lib/app/data/services/base/BaseCategory.dart

import '../../../data/models/Category.dart';

abstract class BaseCategoryApiService {
  /// GET /api/Category - Tüm kategorileri getirir
  Future<dynamic> getAllCategories();

  /// GET /api/Category/{id} - ID'ye göre kategori detayı getirir
  Future<dynamic> getCategoryById(int id);

  /// POST /api/Category - Yeni kategori ekler
  Future<dynamic> addCategory(CategoryModel category);

  /// PUT /api/Category/{id} - Kategoriyi günceller
  Future<dynamic> updateCategory(int id, CategoryModel category);

  /// DELETE /api/Category/{id} - Kategoriyi siler
  Future<dynamic> deleteCategory(int id);
}