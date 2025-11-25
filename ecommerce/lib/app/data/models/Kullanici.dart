class KullaniciModel {
  final int id;
  final String? ad;
  final String? soyad;
  final String? eposta;
  final String? sifre;
  final DateTime? dogumTarihi;
  final int rol;
  final String? telefon;
  final String? addressId;
  final DateTime dateCreated;
  final DateTime dateUpdated;

  KullaniciModel({
    required this.id,
    this.ad,
    this.soyad,
    this.eposta,
    this.sifre,
    this.dogumTarihi,
    required this.rol,
    this.telefon,
    this.addressId,
    required this.dateCreated,
    required this.dateUpdated,
  });

  /// JSON’dan model oluşturma
  factory KullaniciModel.fromJson(Map<String, dynamic> json) {
    DateTime? _parseDate(dynamic date) {
      if (date == null) return null;
      if (date is DateTime) return date;
      return DateTime.tryParse(date.toString());
    }

    return KullaniciModel(
      id: json['id'] ?? 0,
      ad: json['ad'],
      soyad: json['soyad'],
      eposta: json['eposta'],
      sifre: json['sifre'],
      dogumTarihi: _parseDate(json['dogumTarihi']),
      rol: json['rol'] ?? 0,
      telefon: json['telefon'],
      addressId: json['addressId'],
      dateCreated: _parseDate(json['dateCreated']) ?? DateTime.now(),
      dateUpdated: _parseDate(json['dateUpdated']) ?? DateTime.now(),
    );
  }

  /// JWT payload veya özel dictionary’den model oluşturma (isteğe bağlı)
  factory KullaniciModel.fromPayload(Map<String, dynamic> payload) {
    return KullaniciModel(
      id: int.tryParse(payload['Id']?.toString() ?? '0') ?? 0,
      ad: payload['Ad'],
      soyad: payload['Soyad'],
      eposta: payload['Eposta'],
      sifre: null,
      dogumTarihi: null,
      rol: int.tryParse(payload['Rol']?.toString() ?? '0') ?? 0,
      telefon: payload['Telefon'],
      addressId: payload['AddressId'],
      dateCreated: DateTime.now(),
      dateUpdated: DateTime.now(),
    );
  }

  /// JSON’a dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad': ad,
      'soyad': soyad,
      'eposta': eposta,
      'sifre': sifre,
      'dogumTarihi': dogumTarihi?.toIso8601String(),
      'rol': rol,
      'telefon': telefon,
      'addressId': addressId,
      'dateCreated': dateCreated.toIso8601String(),
      'dateUpdated': dateUpdated.toIso8601String(),
    };
  }
}
