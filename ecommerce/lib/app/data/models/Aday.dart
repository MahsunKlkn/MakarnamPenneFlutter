class AdayModel {
  final int id;
  final int kullaniciId;
  final String ad;
  final String soyad;
  final String? webSayfasi;
  final String? unvan;
  final int? tecrube;
  final DateTime dogumTarihi;
  final String? dogumYeri;
  final String telefon;
  final String eposta;
  final String? adres;
  final int? ilId;
  final int? ilceId;
  final String? tcKimlikNo;
  final int uyrukId;
  final String? medeniHal;
  final int? cinsiyet;
  final String? mevcutCalismaDurumu;
  final String? calismaSekli;
  final String? askerlikDurumu;
  final DateTime? tecilTarihi;
  final bool? vardiyaliCalisma;
  final bool? lojmanTalebi;
  final bool? seyahatEngeli;
  final bool? aktifAracKullanimi;
  final bool? ehliyet;
  final String? ehliyetSinifi;
  final bool? engellilikDurumu;
  final String? engellilikDurumuNedeni;
  final bool? saglikSorunu;
  final String? saglikSorunuNedeni;
  final String? kisiselHobiler;
  final String? hakkimda;
  final bool durum;
  final DateTime? kayitTarihi;
  final bool? genelBasvuru;
  final int? genelBasvuruReddedenId;
  final String? basvurulanDepartman;
  final String? basvurulanPozisyon;
  final String? basvurulanOtelIds;
  final String? cvFileName;
  final String? cvUrl;
  final String? imgFileName;
  final String? imgUrl;
  final String? selectedCities;
  final String? cvData;
  final String? fotoData;

  AdayModel({
    required this.id,
    required this.kullaniciId,
    required this.ad,
    required this.soyad,
    this.webSayfasi,
    this.unvan,
    this.tecrube,
    required this.dogumTarihi,
    this.dogumYeri,
    required this.telefon,
    required this.eposta,
    this.adres,
    this.ilId,
    this.ilceId,
    this.tcKimlikNo,
    required this.uyrukId,
    this.medeniHal,
    this.cinsiyet,
    this.mevcutCalismaDurumu,
    this.calismaSekli,
    this.askerlikDurumu,
    this.tecilTarihi,
    this.vardiyaliCalisma,
    this.lojmanTalebi,
    this.seyahatEngeli,
    this.aktifAracKullanimi,
    this.ehliyet,
    this.ehliyetSinifi,
    this.engellilikDurumu,
    this.engellilikDurumuNedeni,
    this.saglikSorunu,
    this.saglikSorunuNedeni,
    this.kisiselHobiler,
    this.hakkimda,
    required this.durum,
    this.kayitTarihi,
    this.genelBasvuru,
    this.genelBasvuruReddedenId,
    this.basvurulanDepartman,
    this.basvurulanPozisyon,
    this.basvurulanOtelIds,
    this.cvFileName,
    this.cvUrl,
    this.imgFileName,
    this.imgUrl,
    this.selectedCities,
    this.cvData,
    this.fotoData,
  });

  factory AdayModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse DateTime strings
    DateTime? _parseDate(String? dateStr) {
      if (dateStr == null) return null;
      return DateTime.tryParse(dateStr);
    }

    return AdayModel(
      id: json['id'] ?? 0,
      kullaniciId: json['kullaniciId'] ?? 0,
      ad: json['ad'] ?? '',
      soyad: json['soyad'] ?? '',
      webSayfasi: json['webSayfasi'],
      unvan: json['unvan'],
      tecrube: json['tecrübe'],
      dogumTarihi: _parseDate(json['dogumTarihi']) ?? DateTime.now(),
      dogumYeri: json['dogumYeri'],
      telefon: json['telefon'] ?? '',
      eposta: json['eposta'] ?? '',
      adres: json['adres'],
      ilId: json['ilId'],
      ilceId: json['ilceId'],
      tcKimlikNo: json['tcKimlikNo'],
      uyrukId: json['uyrukId'] ?? 0,
      medeniHal: json['medeniHal'],
      cinsiyet: json['cinsiyet'],
      mevcutCalismaDurumu: json['mevcutCalismaDurumu'],
      calismaSekli: json['calismaSekli'],
      askerlikDurumu: json['askerlikDurumu'],
      tecilTarihi: _parseDate(json['tecilTarihi']),
      vardiyaliCalisma: json['vardiyaliCalisma'],
      lojmanTalebi: json['lojmanTalebi'],
      seyahatEngeli: json['seyahatEngeli'],
      aktifAracKullanimi: json['aktifAracKullanimi'],
      ehliyet: json['ehliyet'],
      ehliyetSinifi: json['ehliyetSinifi'],
      engellilikDurumu: json['engellilikDurumu'],
      engellilikDurumuNedeni: json['engellilikDurumuNedeni'],
      saglikSorunu: json['saglikSorunu'],
      saglikSorunuNedeni: json['saglikSorunuNedeni'],
      kisiselHobiler: json['kisiselHobiler'],
      hakkimda: json['hakkimda'],
      durum: json['durum'] ?? false,
      kayitTarihi: _parseDate(json['kayitTarihi']),
      genelBasvuru: json['genelBasvuru'],
      genelBasvuruReddedenId: json['genelBasvuruReddedenId'],
      basvurulanDepartman: json['basvurulanDepartman'],
      basvurulanPozisyon: json['basvurulanPozisyon'],
      basvurulanOtelIds: json['basvurulanOtelIds'],
      cvFileName: json['cvFileName'],
      cvUrl: json['cvUrl'],
      imgFileName: json['imgFileName'],
      imgUrl: json['imgUrl'],
      selectedCities: json['selectedCities'],
      cvData: json['cvData'],
      fotoData: json['fotoData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kullaniciId': kullaniciId,
      'ad': ad,
      'soyad': soyad,
      'webSayfasi': webSayfasi,
      'unvan': unvan,
      'tecrübe': tecrube,
      'dogumTarihi': dogumTarihi.toIso8601String(),
      'dogumYeri': dogumYeri,
      'telefon': telefon,
      'eposta': eposta,
      'adres': adres,
      'ilId': ilId,
      'ilceId': ilceId,
      'tcKimlikNo': tcKimlikNo,
      'uyrukId': uyrukId,
      'medeniHal': medeniHal,
      'cinsiyet': cinsiyet,
      'mevcutCalismaDurumu': mevcutCalismaDurumu,
      'calismaSekli': calismaSekli,
      'askerlikDurumu': askerlikDurumu,
      'tecilTarihi': tecilTarihi?.toIso8601String(),
      'vardiyaliCalisma': vardiyaliCalisma,
      'lojmanTalebi': lojmanTalebi,
      'seyahatEngeli': seyahatEngeli,
      'aktifAracKullanimi': aktifAracKullanimi,
      'ehliyet': ehliyet,
      'ehliyetSinifi': ehliyetSinifi,
      'engellilikDurumu': engellilikDurumu,
      'engellilikDurumuNedeni': engellilikDurumuNedeni,
      'saglikSorunu': saglikSorunu,
      'saglikSorunuNedeni': saglikSorunuNedeni,
      'kisiselHobiler': kisiselHobiler,
      'hakkimda': hakkimda,
      'durum': durum,
      'kayitTarihi': kayitTarihi?.toIso8601String(),
      'genelBasvuru': genelBasvuru,
      'genelBasvuruReddedenId': genelBasvuruReddedenId,
      'basvurulanDepartman': basvurulanDepartman,
      'basvurulanPozisyon': basvurulanPozisyon,
      'basvurulanOtelIds': basvurulanOtelIds,
      'cvFileName': cvFileName,
      'cvUrl': cvUrl,
      'imgFileName': imgFileName,
      'imgUrl': imgUrl,
      'selectedCities': selectedCities,
      'cvData': cvData,
      'fotoData': fotoData,
    };
  }
}