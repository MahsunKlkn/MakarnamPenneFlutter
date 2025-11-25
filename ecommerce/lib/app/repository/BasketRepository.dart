import 'dart:convert';

import '../data/models/Basket.dart';
import '../data/services/base/BaseBasket.dart'; // BaseBasketApiService'in konumu

class BasketRepository implements BaseBasketApiService {
  final BaseBasketApiService _api;

  BasketRepository(this._api);
  @override
  Future<List<BasketModel>> getAllBaskets() async {
    try {
      final result = await _api.getAllBaskets();
      final baskets = <BasketModel>[];
      for (var item in result) {
        try {
          if (item is Map<String, dynamic>) {
            baskets.add(BasketModel.fromJson(item as Map<String, dynamic>));
          }
        } catch (e, stackTrace) {
          print(
            '❌ BASKET JSON PARSE HATASI (getAllBaskets): ${jsonEncode(item)} -> Hata: $e',
          );
          print('Stack Trace: $stackTrace');
        }
      }
      print('📦 Repository - Toplam ${baskets.length} sepet yüklendi.');
      return baskets;
    } catch (e, stackTrace) {
      print('❌ API HATASI (getAllBaskets): $e');
      print('Stack Trace: $stackTrace');
      return [];
    }
  }

  @override
  Future<BasketModel?> getBasketById(int id) async {
    try {
      final result = await _api.getBasketById(id);
      if (result is Map<String, dynamic>) {
        return BasketModel.fromJson(result as Map<String, dynamic>);
      }
      return null;
    } catch (e, stackTrace) {
      print('❌ API HATASI (getBasketById $id): $e');
      print('Stack Trace: $stackTrace');
      return null;
    }
  }

  @override
  Future<BasketModel?> getBasketByUserId(int userId) async {
    try {
      final result = await _api.getBasketByUserId(userId);
      
      print('📦 Repository - getBasketByUserId response type: ${result.runtimeType}');
      
      if (result != null) {
        print('✅ Repository - Kullanıcı $userId için sepet bulundu: ID ${result.id}');
        return result;
      }
      
      print('ℹ️ Repository - Kullanıcı $userId için sepet bulunamadı');
      return null;
    } catch (e, stackTrace) {
      print('❌ API HATASI (getBasketByUserId $userId): $e');
      print('Stack Trace: $stackTrace');
      return null;
    }
  }

  @override
  Future<bool> deleteBasket(int id) async {
    try {
      await _api.deleteBasket(id);
      print('📦 Repository - Sepet silindi: (ID: $id)');
      return true;
    } catch (e, stackTrace) {
      print('❌ API HATASI (deleteBasket $id): $e');
      print('Stack Trace: $stackTrace');
      return false;
    }
  }

  @override
  Future<BasketModel?> addBasket(BasketModel basket) async {
    try {
      final result = await _api.addBasket(basket);
      if (result != null) {
        print(
          '📦 Repository - Sepet eklendi: (Kullanıcı ID: ${basket.kullaniciId})',
        );
        return result;
      }
      return null;
    } catch (e, stackTrace) {
      print(
        '❌ API HATASI (addBasket, Kullanıcı ID: ${basket.kullaniciId}): $e',
      );
      print('Stack Trace: $stackTrace');
      return null;
    }
  }

  @override
  Future<BasketModel?> updateBasket(int id, BasketModel basket) async {
    try {
      final result = await _api.updateBasket(id, basket);
      if (result != null) {
        print(
          '📦 Repository - Sepet güncellendi: (ID: $id)',
        );
        return result;
      }
      return null;
    } catch (e, stackTrace) {
      print(
        '❌ API HATASI (updateBasket, ID: $id): $e',
      );
      print('Stack Trace: $stackTrace');
      return null;
    }
  }

  @override
  Future<List<BasketModel>> getBasketsByUserId(int userId) async {
    try {
      final result = await _api.getBasketsByUserId(userId);
      print(
          '📦 Repository - Kullanıcı ID $userId için ${result.length} sepet yüklendi.');
      return result;
    } catch (e, stackTrace) {
      print('❌ API HATASI (getBasketsByUserId $userId): $e');
      print('Stack Trace: $stackTrace');
      return [];
    }
  }

  /// Kullanıcı ID'sine göre sepeti günceller - sadece productIds göndererek
  Future<BasketModel?> updateBasketByUserId(int userId, String productIds) async {
    try {
      // API servisini cast et
      final apiService = _api as dynamic;
      final result = await apiService.updateBasketByUserId(userId, productIds);
      if (result != null) {
        print('📦 Repository - Kullanıcı $userId için sepet güncellendi');
        return result;
      }
      return null;
    } catch (e, stackTrace) {
      print('❌ API HATASI (updateBasketByUserId, Kullanıcı ID: $userId): $e');
      print('Stack Trace: $stackTrace');
      return null;
    }
  }
}
