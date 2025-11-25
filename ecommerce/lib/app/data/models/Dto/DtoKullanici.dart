class DtoKullaniciModel {
  final int id;
  final String? ad;
  final String? soyad;
  final String? sirketAdi;
  final String? gorev;
  final String? telefon;
  final String? sifre;
  final DateTime? dogumTarihi;
  final String? tcKimlikNo;
  final String? referansTelNo;
  final String? referansAd;
  final String? sehir;
  final DateTime? kayitTarihi;
  final DateTime? onayRedTarihi;
  final String? linkKayit;
  final DateTime? updatedDate;

  DtoKullaniciModel({
    required this.id,
    this.ad,
    this.soyad,
    this.sirketAdi,
    this.gorev,
    this.telefon,
    this.sifre,
    this.dogumTarihi,
    this.tcKimlikNo,
    this.referansTelNo,
    this.referansAd,
    this.sehir,
    this.kayitTarihi,
    this.onayRedTarihi,
    this.linkKayit,
    this.updatedDate,
  });

  factory DtoKullaniciModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse DateTime strings
    DateTime? _parseDate(String? dateStr) {
      if (dateStr == null) return null;
      return DateTime.tryParse(dateStr);
    }

    return DtoKullaniciModel(
      id: json['id'] ?? 0,
      ad: json['ad'],
      soyad: json['soyad'],
      sirketAdi: json['sirketAdi'],
      gorev: json['gorev'],
      telefon: json['telefon'],
      sifre: json['sifre'],
      dogumTarihi: _parseDate(json['dogumTarihi']),
      tcKimlikNo: json['tcKimlikNo'],
      referansTelNo: json['referansTelNo'],
      referansAd: json['referansAd'],
      sehir: json['sehir'],
      kayitTarihi: _parseDate(json['kayitTarihi']),
      onayRedTarihi: _parseDate(json['onayRedTarihi']),
      linkKayit: json['linkKayit'],
      updatedDate: _parseDate(json['updatedDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad': ad,
      'soyad': soyad,
      'sirketAdi': sirketAdi,
      'gorev': gorev,
      'telefon': telefon,
      'sifre': sifre,
      'dogumTarihi': dogumTarihi?.toIso8601String(),
      'tcKimlikNo': tcKimlikNo,
      'referansTelNo': referansTelNo,
      'referansAd': referansAd,
      'sehir': sehir,
      'kayitTarihi': kayitTarihi?.toIso8601String(),
      'onayRedTarihi': onayRedTarihi?.toIso8601String(),
      'linkKayit': linkKayit,
      'updatedDate': updatedDate?.toIso8601String(),
    };
  }
}