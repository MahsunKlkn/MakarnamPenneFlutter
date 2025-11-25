import 'package:flutter/material.dart';
import '../data/models/Basket.dart';
import '../repository/BasketRepository.dart';
import '../core/services/service_locator.dart';

class BasketViewModel extends ChangeNotifier {
  final BasketRepository _basketRepository = locator<BasketRepository>();

  BasketModel? _userBasket;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  BasketModel? get userBasket => _userBasket;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Sepetteki ürün sayısını döndürür
  int get basketItemCount {
    if (_userBasket == null || _userBasket!.productIds == null) return 0;
    return _userBasket!.getProductIdsList().length;
  }

  /// Kullanıcının sepetini yükler
  Future<void> loadUserBasket(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('🛒 BasketViewModel: Kullanıcı $userId için sepet yükleniyor...');
      
      _userBasket = await _basketRepository.getBasketByUserId(userId);
      
      if (_userBasket != null) {
        print('✅ Sepet yüklendi - ID: ${_userBasket!.id}');
        print('📦 Ürünler: ${_userBasket!.productIds}');
      } else {
        print('ℹ️ Kullanıcının sepeti yok');
      }
    } catch (e) {
      _errorMessage = 'Sepet yüklenirken hata oluştu: $e';
      print('❌ $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sepete ürün ekler veya günceller
  Future<bool> addProductToBasket(int userId, int productId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('🛒 BasketViewModel: Kullanıcı $userId için ürün $productId ekleniyor...');
      
      // Kullanıcının sepetini getir
      BasketModel? existingBasket = await _basketRepository.getBasketByUserId(userId);

      if (existingBasket != null) {
        // ✅ Sepet var - Güncelle
        print('📦 Mevcut sepet bulundu - ID: ${existingBasket.id}');
        print('📦 Mevcut ürünler: ${existingBasket.productIds}');
        
        List<int> currentProductIds = existingBasket.getProductIdsList();
        
        // Aynı üründen birden fazla eklenebilir, direkt ekle
        currentProductIds.add(productId);
        String updatedProductIds = currentProductIds.join(',');
        
        print('📦 Güncellenmiş ürünler: $updatedProductIds');
        
        // Sepeti güncelle - Kullanıcı ID ve productIds ile
        print('📤 PUT UpdateByKullaniciId/$userId - ProductIds: $updatedProductIds');
        
        final result = await _basketRepository.updateBasketByUserId(
          userId,
          updatedProductIds,
        );
        
        if (result != null) {
          _userBasket = result;
          print('✅ Sepet güncellendi!');
          _isLoading = false;
          notifyListeners();
          return true;
        }
      } else {
        // ✅ Sepet yok - Yeni oluştur
        print('📦 Kullanıcının sepeti yok, yeni sepet oluşturuluyor...');
        
        BasketModel newBasket = BasketModel(
          id: 0,
          kullaniciId: userId,
          productIds: productId.toString(),
          products: [],
        );
        
        print('📤 POST: ${newBasket.toJson()}');
        
        final result = await _basketRepository.addBasket(newBasket);
        
        if (result != null) {
          _userBasket = result;
          print('✅ Yeni sepet oluşturuldu!');
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }
      
      _errorMessage = 'Ürün eklenirken bir hata oluştu';
      _isLoading = false;
      notifyListeners();
      return false;
      
    } catch (e) {
      _errorMessage = 'Ürün eklenirken hata oluştu: $e';
      print('❌ BasketViewModel: $_errorMessage');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sepetten ürün çıkarır
  Future<bool> removeProductFromBasket(int userId, int productId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('🛒 BasketViewModel: Kullanıcı $userId için ürün $productId çıkarılıyor...');
      
      // Önce mevcut sepeti kontrol et (cache'den veya API'den)
      BasketModel? existingBasket = _userBasket;
      
      // Cache'de yoksa API'den çek
      if (existingBasket == null || existingBasket.kullaniciId != userId) {
        print('📦 BasketViewModel: Sepet cache\'de yok, API\'den getiriliyor...');
        existingBasket = await _basketRepository.getBasketByUserId(userId);
        _userBasket = existingBasket;
      }

      if (existingBasket != null) {
        List<int> currentProductIds = existingBasket.getProductIdsList();
        
        if (!currentProductIds.contains(productId)) {
          print('ℹ️ BasketViewModel: Ürün $productId sepette bulunamadı');
          _errorMessage = 'Bu ürün sepetinizde bulunamadı';
          _isLoading = false;
          notifyListeners();
          return false;
        }
        
        // Ürünü çıkar (sadece 1 adet)
        currentProductIds.remove(productId);
        
        print('📦 BasketViewModel: Güncellenmiş ürünler: $currentProductIds');
        
        if (currentProductIds.isEmpty) {
          // Sepette ürün kalmadıysa sepeti sil
          print('📦 BasketViewModel: Sepette ürün kalmadı, sepet siliniyor...');
          final deleted = await _basketRepository.deleteBasket(existingBasket.id);
          if (deleted) {
            _userBasket = null;
            print('✅ BasketViewModel: Sepet silindi');
            _isLoading = false;
            notifyListeners();
            return true;
          }
        } else {
          // Sepeti güncelle
          String updatedProductIds = currentProductIds.join(',');
          
          print('📤 PUT UpdateByKullaniciId/$userId - ProductIds: $updatedProductIds');
          
          final result = await _basketRepository.updateBasketByUserId(
            userId,
            updatedProductIds,
          );
          
          if (result != null) {
            _userBasket = result;
            print('✅ BasketViewModel: Ürün sepetten çıkarıldı (Yeni productIds: ${result.productIds})');
            _isLoading = false;
            notifyListeners();
            return true;
          }
        }
      } else {
        print('ℹ️ BasketViewModel: Kullanıcının sepeti bulunamadı');
        _errorMessage = 'Sepet bulunamadı';
      }
      
      _isLoading = false;
      notifyListeners();
      return false;
      
    } catch (e) {
      _errorMessage = 'Ürün çıkarılırken hata oluştu: $e';
      print('❌ BasketViewModel: $_errorMessage');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sepeti tamamen temizler
  Future<bool> clearBasket(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('🛒 BasketViewModel: Kullanıcı $userId için sepet temizleniyor...');
      
      // Önce mevcut sepeti kontrol et (cache'den veya API'den)
      BasketModel? existingBasket = _userBasket;
      
      // Cache'de yoksa API'den çek
      if (existingBasket == null || existingBasket.kullaniciId != userId) {
        print('📦 BasketViewModel: Sepet cache\'de yok, API\'den getiriliyor...');
        existingBasket = await _basketRepository.getBasketByUserId(userId);
      }

      if (existingBasket != null) {
        final deleted = await _basketRepository.deleteBasket(existingBasket.id);
        if (deleted) {
          _userBasket = null;
          print('✅ BasketViewModel: Sepet temizlendi');
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }
      
      _isLoading = false;
      notifyListeners();
      return false;
      
    } catch (e) {
      _errorMessage = 'Sepet temizlenirken hata oluştu: $e';
      print('❌ BasketViewModel: $_errorMessage');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Bir ürünün sepette olup olmadığını kontrol eder
  bool isProductInBasket(int productId) {
    if (_userBasket == null || _userBasket!.productIds == null) return false;
    return _userBasket!.getProductIdsList().contains(productId);
  }

  /// Kullanıcının duplicate sepetlerini birleştirir
  Future<bool> mergeDuplicateBaskets(int userId) async {
    try {
      print('🔄 BasketViewModel: Kullanıcı $userId için duplicate sepetler kontrol ediliyor...');
      
      // Tüm sepetleri getir
      final allBaskets = await _basketRepository.getBasketsByUserId(userId);
      
      if (allBaskets.length <= 1) {
        print('ℹ️ BasketViewModel: Birleştirilecek duplicate sepet yok');
        return true;
      }
      
      print('⚠️ BasketViewModel: ${allBaskets.length} adet sepet bulundu, birleştiriliyor...');
      
      // Tüm ürün ID'lerini topla
      Set<int> allProductIds = {};
      BasketModel? mainBasket;
      DateTime? earliestDate;
      
      for (var basket in allBaskets) {
        allProductIds.addAll(basket.getProductIdsList());
        
        // En eski sepeti ana sepet olarak kullan
        if (earliestDate == null || 
            (basket.dateCreated != null && basket.dateCreated!.isBefore(earliestDate))) {
          earliestDate = basket.dateCreated;
          mainBasket = basket;
        }
      }
      
      if (mainBasket == null) {
        mainBasket = allBaskets.first;
      }
      
      // Ana sepeti güncelle
      String mergedProductIds = allProductIds.toList().join(',');
      
      BasketModel updatedBasket = BasketModel(
        id: mainBasket.id,
        kullaniciId: userId,
        productIds: mergedProductIds,
        products: [],
        dateCreated: mainBasket.dateCreated,
        dateUpdated: DateTime.now(),
      );
      
      print('📦 BasketViewModel: Ana sepet ID: ${mainBasket.id}, Birleştirilmiş ürünler: $mergedProductIds');
      
      // Ana sepeti güncelle
      final result = await _basketRepository.updateBasket(mainBasket.id, updatedBasket);
      
      if (result != null) {
        // Diğer sepetleri sil
        for (var basket in allBaskets) {
          if (basket.id != mainBasket.id) {
            print('🗑️ BasketViewModel: Duplicate sepet siliniyor: ID ${basket.id}');
            await _basketRepository.deleteBasket(basket.id);
          }
        }
        
        _userBasket = result;
        print('✅ BasketViewModel: Sepetler başarıyla birleştirildi!');
        return true;
      }
      
      return false;
    } catch (e) {
      print('❌ BasketViewModel: Sepet birleştirme hatası: $e');
      return false;
    }
  }
}
