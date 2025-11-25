import '../../models/Basket.dart';

abstract class BaseBasketApiService {
  /// Tüm sepetleri getirir (Genellikle admin için)
  Future<List<BasketModel>> getAllBaskets();

  /// ID'ye göre tek bir sepeti getirir
  Future<BasketModel?> getBasketById(int id);

  /// Kullanıcı ID'sine göre kullanıcının sepetini getirir
  Future<BasketModel?> getBasketByUserId(int userId);

  /// Yeni bir sepet oluşturur (veya varolanı günceller)
  Future<BasketModel?> addBasket(BasketModel basket);

  /// ID'ye göre sepeti günceller
  Future<BasketModel?> updateBasket(int id, BasketModel basket);

  /// Sepeti ID'ye göre siler
  Future<bool> deleteBasket(int id);

  /// Kullanıcı ID'sine göre sepetleri getirir
  Future<List<BasketModel>> getBasketsByUserId(int userId);
}