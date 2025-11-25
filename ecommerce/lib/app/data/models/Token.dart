class TokenModel {
  final int Id;
  final String? Eposta;
  final String? Ad;
  final String? Soyad;
  final String? SirketAdi;
  final int Rol;
  final int? Domain;
  final int? AdayId;
  final int? SirketId;

  TokenModel({
    required this.Id,
    required this.Rol,
    this.Eposta,
    this.Ad,
    this.Soyad,
    this.SirketAdi,
    this.Domain,
    this.AdayId,
    this.SirketId,
  });

  // HATA BU METODUN EKSİK OLMASINDAN VEYA YANLIŞ YAZILMASINDAN KAYNAKLANIYOR
  factory TokenModel.fromPayload(Map<String, dynamic> payload) {
    // String'leri güvenli bir şekilde int'e çeviren yardımcı fonksiyon
    int? _tryParseInt(String? value) {
      if (value == null) return null;
      return int.tryParse(value);
    }

    return TokenModel(
      // Zorunlu alanlar için varsayılan değer ataması
      Id: _tryParseInt(payload['Id']) ?? 0,
      Rol: _tryParseInt(payload['Rol']) ?? 0,
      
      // String alanlar
      Eposta: payload['Eposta'],
      Ad: payload['Ad'],
      Soyad: payload['Soyad'],
      SirketAdi: payload['SirketAdi'],

      // Null olabilecek integer alanlar
      AdayId: _tryParseInt(payload['AdayId']),
      SirketId: _tryParseInt(payload['SirketId']),
      Domain: _tryParseInt(payload['Domain']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': Id,
      'Eposta': Eposta,
      'Ad': Ad,
      'Soyad': Soyad,
      'SirketAdi': SirketAdi,
      'Rol': Rol,
      'Domain': Domain,
      'AdayId': AdayId,
      'SirketId': SirketId,
    };
  }
}