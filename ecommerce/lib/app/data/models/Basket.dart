// ProductModel'in bulunduğu yolu doğru şekilde güncelleyin
import 'Product.dart'; // veya 'product_model.dart'

class BasketModel {
  final int id;
  final int kullaniciId;
  final List<ProductModel>? products; // API'den gelen products listesi (opsiyonel)
  final String? productIds; // API'den gelen ürün ID'leri (7,8,9 formatında)
  final DateTime? dateCreated;
  final DateTime? dateUpdated;

  BasketModel({
    required this.id,
    required this.kullaniciId,
    this.products,
    this.productIds,
    this.dateCreated,
    this.dateUpdated,
  });

  /// JSON'dan BasketModel oluştur
  factory BasketModel.fromJson(Map<String, dynamic> json) {
    return BasketModel(
      id: json['id'] as int,
      kullaniciId: json['kullaniciId'] as int,
      productIds: json['productIds'] as String?,
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      dateCreated: json['dateCreated'] != null 
          ? DateTime.parse(json['dateCreated'] as String)
          : null,
      dateUpdated: json['dateUpdated'] != null
          ? DateTime.parse(json['dateUpdated'] as String)
          : null,
    );
  }

  /// BasketModel'i JSON'a dönüştür (API'ye gönderirken)
  Map<String, dynamic> toJson({bool isUpdate = false}) {
    // Backend'in beklediği format
    // Güncelleme sırasında tarihleri göndermiyoruz - EF tracking hatasını önler
    
    if (isUpdate) {
      // PUT isteği - Sadece gerekli alanları gönder
      return {
        'id': id,
        'kullaniciId': kullaniciId,
        'productIds': productIds ?? '',
      };
    } else {
      // POST isteği - Yeni sepet
      return {
        'id': 0,
        'kullaniciId': kullaniciId,
        'productIds': productIds ?? '',
      };
    }
  }

  /// ProductIds string'ini liste halinde döndürür
  List<int> getProductIdsList() {
    if (productIds == null || productIds!.isEmpty) return [];
    return productIds!
        .split(',')
        .map((id) => int.tryParse(id.trim()))
        .where((id) => id != null)
        .cast<int>()
        .toList();
  }
}