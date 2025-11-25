import 'package:dio/dio.dart';
import '../../core/config/config.dart';
import 'base/BaseBasket.dart'; // Oluşturduğumuz Interface
import '../models/Basket.dart'; // BasketModel'in konumu

// ProductApiService'den kopyalanan Hata Yönetim Fonksiyonu
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

class BasketApiService implements BaseBasketApiService {
  final Dio _dio;
  final String _serviceUrl;

  BasketApiService(this._dio)
      : _serviceUrl = '${AppConfig.instance.apiBaseUrl}/Basket';

  @override
  Future<List<BasketModel>> getAllBaskets() async {
    try {
      final response = await _dio.get(_serviceUrl);
      if (response.data is List) {
        return (response.data as List)
            .map((e) => BasketModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Beklenmeyen API yanıtı formatı (List bekleniyordu)");
      }
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return [];
    }
  }

  /// ✅ ID'ye göre sepeti getirir
  @override
  Future<BasketModel?> getBasketById(int id) async {
    try {
      final response = await _dio.get('$_serviceUrl/$id');
      if (response.data is Map<String, dynamic>) {
        return BasketModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<BasketModel?> getBasketByUserId(int userId) async {
    try {
      // Backend'de /user/{userId} endpoint'i yoksa GetByKullaniciId kullan
      final response = await _dio.get('$_serviceUrl/GetByKullaniciId/$userId');
      
      print('🔍 BasketApiService: Kullanıcı $userId için sepet sorgulandı');
      print('📦 Response Type: ${response.data.runtimeType}');
      print('📦 Response Data: ${response.data}');
      
      if (response.data is List) {
        final List<BasketModel> baskets = (response.data as List)
            .map((e) => BasketModel.fromJson(e as Map<String, dynamic>))
            .toList();
        
        print('✅ Toplam ${baskets.length} sepet bulundu');
        
        // Kullanıcının ilk sepetini döndür (en son güncellenen)
        if (baskets.isNotEmpty) {
          // En son güncellenen sepeti bul
          baskets.sort((a, b) => (b.dateUpdated ?? DateTime(2000))
              .compareTo(a.dateUpdated ?? DateTime(2000)));
          
          print('📦 Döndürülen sepet ID: ${baskets.first.id}');
          return baskets.first;
        }
        return null;
      } else if (response.data is Map<String, dynamic>) {
        return BasketModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<List<BasketModel>> getBasketsByUserId(int userId) async {
    try {
      final response = await _dio.get('$_serviceUrl/GetByKullaniciId/$userId');
      if (response.data is List) {
        return (response.data as List)
            .map((e) => BasketModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Beklenmeyen API yanıtı formatı");
      }
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return [];
    }
  }

  @override
  Future<BasketModel?> addBasket(BasketModel basket) async {
    try {
      final response = await _dio.post(
        _serviceUrl,
        data: basket.toJson(),
      );

      if (response.data is Map<String, dynamic>) {
        return BasketModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<BasketModel?> updateBasket(int id, BasketModel basket) async {
    try {
      final response = await _dio.put(
        '$_serviceUrl/$id',
        data: basket.toJson(isUpdate: true),
      );
      if (response.data is Map<String, dynamic>) {
        return BasketModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  /// Kullanıcı ID'sine göre sepeti günceller - sadece productIds göndererek
  Future<BasketModel?> updateBasketByUserId(int userId, String productIds) async {
    try {
      final response = await _dio.put(
        '$_serviceUrl/user/$userId',
        data: {
          'productIds': productIds,
        },
      );
      if (response.data is Map<String, dynamic>) {
        return BasketModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<bool> deleteBasket(int id) async {
    try {
      await _dio.delete('$_serviceUrl/$id');
      return true;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return false;
    }
  }
}