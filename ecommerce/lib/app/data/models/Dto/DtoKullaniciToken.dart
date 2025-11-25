import '../Kullanici.dart';

class DtoKullaniciToken {
  KullaniciModel? kullanici;
  String? adayId;
  String? sirketId;

  DtoKullaniciToken({
    this.kullanici,
    this.adayId,
    this.sirketId,
  });

  factory DtoKullaniciToken.fromJson(Map<String, dynamic> json) {
    return DtoKullaniciToken(
      kullanici: json['kullanici'] != null
          ? KullaniciModel.fromJson(json['kullanici'])
          : null,
      adayId: json['adayId'],
      sirketId: json['sirketId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kullanici': kullanici?.toJson(),
      'adayId': adayId,
      'sirketId': sirketId,
    };
  }
}
