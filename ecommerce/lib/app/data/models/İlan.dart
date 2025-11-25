class IlanModel {
  final int id;
  final int sirketId;
  final int durum;
  final int sektorId;
  final int pozisyonId;
  final int pozisyonSeviyeId;
  final int? ilId;
  final int? ilceId;
  final int? minimumTecrube;
  final int? maksimumTecrube;
  final int? egitimSeviyeId;
  final int? surucuBelgesiId;
  final int calismaSekliId;
  final int? calismaModeliId;
  final int? yabanciDilId;
  final int? dilSeviyeId;
  final DateTime yayinlanmaTarihi;
  final String isTanimiNitelik;
  final String? anahtarKelime;
  final int? pasifNeden;
  final DateTime? aktifSure;
  final String? numberOfStars;
  final String? totalRoom;
  final String tenantId;
  final int createdBy;
  final int ulkeId;

  IlanModel({
    required this.id,
    required this.sirketId,
    required this.durum,
    required this.sektorId,
    required this.pozisyonId,
    required this.pozisyonSeviyeId,
    this.ilId,
    this.ilceId,
    this.minimumTecrube,
    this.maksimumTecrube,
    this.egitimSeviyeId,
    this.surucuBelgesiId,
    required this.calismaSekliId,
    this.calismaModeliId,
    this.yabanciDilId,
    this.dilSeviyeId,
    required this.yayinlanmaTarihi,
    required this.isTanimiNitelik,
    this.anahtarKelime,
    this.pasifNeden,
    this.aktifSure,
    this.numberOfStars,
    this.totalRoom,
    required this.tenantId,
    required this.createdBy,
    required this.ulkeId,
  });

  factory IlanModel.fromJson(Map<String, dynamic> json) {
    return IlanModel(
      id: json['id'] ?? 0,
      sirketId: json['sirketId'] ?? 0,
      durum: json['durum'] ?? 0,
      sektorId: json['sektorId'] ?? 0,
      pozisyonId: json['pozisyonId'] ?? 0,
      pozisyonSeviyeId: json['pozisyonSeviyeId'] ?? 0,
      ilId: json['ilId'],
      ilceId: json['ilceId'],
      minimumTecrube: json['minimumTecrube'],
      maksimumTecrube: json['maksimumTecrube'],
      egitimSeviyeId: json['egitimSeviyeId'],
      surucuBelgesiId: json['surucuBelgesiId'],
      calismaSekliId: json['calismaSekliId'] ?? 0,
      calismaModeliId: json['calismaModeliId'],
      yabanciDilId: json['yabanciDilId'],
      dilSeviyeId: json['dilSeviyeId'],
      yayinlanmaTarihi: DateTime.tryParse(json['yayinlanmaTarihi'] ?? '') ?? DateTime.now(),
      isTanimiNitelik: json['isTanimiNitelik'] ?? '',
      anahtarKelime: json['anahtarKelime'],
      pasifNeden: json['pasifNeden'],
      aktifSure: json['aktifSure'] != null ? DateTime.tryParse(json['aktifSure']) : null,
      numberOfStars: json['numberOfStars'],
      totalRoom: json['totalRoom'],
      tenantId: json['tenantId'] ?? '',
      createdBy: json['createdBy'] ?? 0,
      ulkeId: json['ulkeId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sirketId': sirketId,
      'durum': durum,
      'sektorId': sektorId,
      'pozisyonId': pozisyonId,
      'pozisyonSeviyeId': pozisyonSeviyeId,
      'ilId': ilId,
      'ilceId': ilceId,
      'minimumTecrube': minimumTecrube,
      'maksimumTecrube': maksimumTecrube,
      'egitimSeviyeId': egitimSeviyeId,
      'surucuBelgesiId': surucuBelgesiId,
      'calismaSekliId': calismaSekliId,
      'calismaModeliId': calismaModeliId,
      'yabanciDilId': yabanciDilId,
      'dilSeviyeId': dilSeviyeId,
      'yayinlanmaTarihi': yayinlanmaTarihi.toIso8601String(),
      'isTanimiNitelik': isTanimiNitelik,
      'anahtarKelime': anahtarKelime,
      'pasifNeden': pasifNeden,
      'aktifSure': aktifSure?.toIso8601String(),
      'numberOfStars': numberOfStars,
      'totalRoom': totalRoom,
      'tenantId': tenantId,
      'createdBy': createdBy,
      'ulkeId': ulkeId,
    };
  }
}