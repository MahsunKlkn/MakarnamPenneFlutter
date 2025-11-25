import 'dart:convert';
import '../data/models/Dto/DtoIlan.dart';

import '../data/models/İlan.dart';
import '../data/services/base/BaseIlan.dart';


class IlanRepository implements BaseIlanApiService {
  final BaseIlanApiService _api;

  IlanRepository(this._api);

  // --- İlan Listeleme Metotları ---

  /// Tüm aktif ilanları listeler.
  Future<List<IlanListeDtoModel>> getIlanListe() async {
    try {
      final result = await _api.getIlanListe();
      if (result is List) {
        final ilanlar = <IlanListeDtoModel>[];
        for (var item in result) {
          try {
            if (item is Map<String, dynamic>) {
              final ilan = IlanListeDtoModel.fromJson(item);
              // Sadece aktif olanları ekle (state == 1)
              if (ilan.state == 1) {
                ilanlar.add(ilan);
              }
            }
          } catch (e, stackTrace) {
            print(
              '❌ JSON PARSE HATASI (getIlanListe): ${jsonEncode(item)} -> Hata: $e',
            );
            print('Stack Trace: $stackTrace');
          }
        }
        print('📦 Repository - Toplam ${ilanlar.length} aktif ilan yüklendi.');
        return ilanlar;
      }
      return [];
    } catch (e, stackTrace) {
      print('❌ API HATASI (getIlanListe): $e');
      print('Stack Trace: $stackTrace');
      return [];
    }
  }

  /// Belirli bir şirkete ait ilanları listeler.
  Future<List<IlanListeDtoModel>> getIlanListeCompany(String sirketId) async {
    try {
      final result = await _api.getIlanListeCompany(sirketId);
      if (result is List) {
        return result
            .map(
              (item) =>
                  IlanListeDtoModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }
      return [];
    } catch (e) {
      print('❌ API HATASI (getIlanListeCompany): $e');
      return [];
    }
  }

  /// Onay bekleyen ilanları listeler.
  Future<List<IlanListeDtoModel>> getWaitingIlanListe() async {
    try {
      final result = await _api.getWaitingIlanListe();
      if (result is List) {
        return result
            .map(
              (item) =>
                  IlanListeDtoModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }
      return [];
    } catch (e) {
      print('❌ API HATASI (getWaitingIlanListe): $e');
      return [];
    }
  }

  // --- İlan Detay ve Tekil Getirme Metotları ---

  /// ID'ye göre ilan detayını getirir.
  // Future<DtoIlanDetayModel?> fetchJobDetailById(String ilanId) async {
  //   try {
  //     final result = await _api.fetchJobDetailById(ilanId);
  //     if (result is Map<String, dynamic>) {
  //       return DtoIlanDetayModel.fromJson(result);
  //     }
  //     return null;
  //   } catch (e) {
  //     print('❌ API HATASI (fetchJobDetailById): $e');
  //     return null;
  //   }
  // }

  /// ID'ye göre ilanı getirir.
  Future<IlanModel?> fetchJobById(String ilanId) async {
    try {
      final result = await _api.fetchJobById(ilanId);
      if (result is Map<String, dynamic>) {
        return IlanModel.fromJson(result);
      }
      return null;
    } catch (e) {
      print('❌ API HATASI (fetchJobById): $e');
      return null;
    }
  }

  /// ID'ye göre ilanı (yetkisiz) getirir.
  Future<IlanListeDtoModel?> fetchJobByIdNonAuth(String ilanId) async {
    try {
      final result = await _api.fetchJobByIdNonAuth(ilanId);
      if (result is Map<String, dynamic>) {
        return IlanListeDtoModel.fromJson(result);
      }
      return null;
    } catch (e) {
      print('❌ API HATASI (fetchJobByIdNonAuth): $e');
      return null;
    }
  }

  // --- İlan Sayı ve İstatistik Metotları ---

  /// Şirketin toplam ilan sayısını getirir.
  Future<int> totalAdvertCompany(String kullaniciId, String sirketId) async {
    try {
      final result = await _api.totalAdvertCompany(kullaniciId, sirketId);
      return (result as int?) ?? 0;
    } catch (e) {
      print('❌ API HATASI (totalAdvertCompany): $e');
      return 0;
    }
  }

  /// Şirketin silinmiş ilan sayısını getirir.
  Future<int> totalDeleteAdvertCompany(
    String kullaniciId,
    String sirketId,
  ) async {
    try {
      final result = await _api.totalDeleteAdvertCompany(kullaniciId, sirketId);
      return (result as int?) ?? 0;
    } catch (e) {
      print('❌ API HATASI (totalDeleteAdvertCompany): $e');
      return 0;
    }
  }

  /// Şirketin aktif ilan sayısını getirir.
  Future<int> activeAdvertCompany(String kullaniciId, String sirketId) async {
    try {
      final result = await _api.activeAdvertCompany(kullaniciId, sirketId);
      return result ?? 0;
    } catch (e) {
      print('❌ API HATASI (activeAdvertCompany): $e');
      return 0;
    }
  }

  /// Sistemdeki toplam ilan sayısını getirir.
  Future<int> getToplamIlan() async {
    try {
      final result = await _api.getToplamIlan();
      return result ?? 0;
    } catch (e) {
      print('❌ API HATASI (getToplamIlan): $e');
      return 0;
    }
  }

  /// Sistemdeki aktif ilan sayısını getirir.
  Future<int> getAktifIlan() async {
    try {
      final result = await _api.getAktifIlan();
      return result ?? 0;
    } catch (e) {
      print('❌ API HATASI (getAktifIlan): $e');
      return 0;
    }
  }

  /// Onaylanmamış ilan sayısını getirir.
  Future<int> getUnApprovedJobCount() async {
    try {
      final result = await _api.getUnApprovedJobCount();
      return result ?? 0;
    } catch (e) {
      print('❌ API HATASI (getUnApprovedJobCount): $e');
      return 0;
    }
  }

  // --- İlan Durum Güncelleme Metotları ---

  /// Bir ilanı silinmiş olarak işaretler.
  Future<bool> deleteJob(String ilanId) async {
    try {
      final result = await _api.deleteJob(ilanId);
      return result != null;
    } catch (e) {
      print('❌ API HATASI (deleteJob): $e');
      return false;
    }
  }

  /// Bir ilanı pasif olarak işaretler.
  Future<bool> passiveJob(String ilanId) async {
    try {
      final result = await _api.passiveJob(ilanId);
      return result != null;
    } catch (e) {
      print('❌ API HATASI (passiveJob): $e');
      return false;
    }
  }

  /// Bir ilanı onaylar (aktif yapar).
  Future<bool> approveJob(String ilanId) async {
    try {
      final result = await _api.approveJob(ilanId);
      return result != null;
    } catch (e) {
      print('❌ API HATASI (approveJob): $e');
      return false;
    }
  }

  /// Bir ilanı reddeder.
  Future<bool> rejectJob(String ilanId) async {
    try {
      final result = await _api.rejectJob(ilanId);
      return result != null;
    } catch (e) {
      print('❌ API HATASI (rejectJob): $e');
      return false;
    }
  }

  // --- İlan Oluşturma/Güncelleme Metotları ---

  /// Bir ilanı oluşturur veya günceller.
  Future<bool> createUpdatePostJob(Map<String, dynamic> requestBody) async {
    try {
      final result = await _api.createUpdatePostJob(requestBody);
      return result != null;
    } catch (e) {
      print('❌ API HATASI (createUpdatePostJob): $e');
      return false;
    }
  }

  /// Bir ilanın kriterlerini (yıldız puanları) gönderir.
  Future<bool> sendStarRatings(Map<String, dynamic> ilanKriter) async {
    try {
      final result = await _api.sendStarRatings(ilanKriter);
      return result != null;
    } catch (e) {
      print('❌ API HATASI (sendStarRatings): $e');
      return false;
    }
  }

  // --- Diğer Metotlar ---

  /// Belirtilen pozisyon için ilan olup olmadığını kontrol eder.
  Future<bool> hasIlanForPozisyon(String pozisyonId) async {
    try {
      final result = await _api.hasIlanForPozisyon(pozisyonId);
      return result ?? false;
    } catch (e) {
      print('❌ API HATASI (hasIlanForPozisyon): $e');
      return false;
    }
  }

  /// Belirtilen sektör için ilan olup olmadığını kontrol eder.
  Future<bool> hasIlanForSektor(String sektorId) async {
    try {
      final result = await _api.hasIlanForSektor(sektorId);
      return result ?? false;
    } catch (e) {
      print('❌ API HATASI (hasIlanForSektor): $e');
      return false;
    }
  }

  /// İlanın kriterlerini getirir.
  // Future<IlanKriter?> fetchIlanKriter(String ilanId) async {
  //   try {
  //     final result = await _api.fetchIlanKriter(ilanId);
  //     if (result is Map<String, dynamic>) {
  //       return IlanKriter.fromJson(result);
  //     }
  //     return null;
  //   } catch (e) {
  //     print('❌ API HATASI (fetchIlanKriter): $e');
  //     return null;
  //   }
  // }

  // Not: `getCurrentUser` ve `fetchUserById` gibi metotlar aslında bir `UserRepository`
  // içinde daha anlamlı olabilir. Ancak istenildiği için buraya da eklendi.
  // Gelen verinin Map<String, dynamic> olması beklenir.

  /// Mevcut kullanıcı detaylarını getirir.
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final result = await _api.getCurrentUser();
      return result as Map<String, dynamic>?;
    } catch (e) {
      print('❌ API HATASI (getCurrentUser): $e');
      return null;
    }
  }

  /// ID'ye göre kullanıcı detaylarını getirir.
  Future<Map<String, dynamic>?> fetchUserById(String userId) async {
    try {
      final result = await _api.fetchUserById(userId);
      return result as Map<String, dynamic>?;
    } catch (e) {
      print('❌ API HATASI (fetchUserById): $e');
      return null;
    }
  }

  // --- Atlanan İstatistik ve Sayı Metotları ---

  /// Duruma göre ilan sayılarını bir harita olarak getirir. ('aktif': 5, 'pasif': 2 gibi)
  Future<Map<String, int>> getIlanCount() async {
    try {
      final result = await _api.getIlanCount();
      // Gelen verinin Map<String, dynamic> olduğunu ve valueların int olduğunu varsayıyoruz.
      if (result is Map) {
        return Map<String, int>.from(
          result.map(
            (key, value) =>
                MapEntry(key.toString(), (value as num?)?.toInt() ?? 0),
          ),
        );
      }
      return {};
    } catch (e) {
      print('❌ API HATASI (getIlanCount): $e');
      return {};
    }
  }

  /// Sistemdeki tüm ilanların sayısını getirir (filtresiz).
  Future<int> totalAdvert() async {
    try {
      final result = await _api.totalAdvert();
      return result ?? 0;
    } catch (e) {
      print('❌ API HATASI (totalAdvert): $e');
      return 0;
    }
  }

  /// Sistemdeki tüm aktif ilanların sayısını getirir.
  Future<int> activeAdvert() async {
    try {
      final result = await _api.activeAdvert();
      return result ?? 0;
    } catch (e) {
      print('❌ API HATASI (activeAdvert): $e');
      return 0;
    }
  }

  /// Toplam aday kayıt sayısını getirir.
  Future<int> candidateRegistrationNumber() async {
    try {
      final result = await _api.candidateRegistrationNumber();
      return (result as int?) ?? 0;
    } catch (e) {
      print('❌ API HATASI (candidateRegistrationNumber): $e');
      return 0;
    }
  }

  /// Şirkete ait aday kayıt sayısını getirir.
  Future<int> candidateRegistrationNumberCompany(String kullaniciId) async {
    try {
      final result = await _api.candidateRegistrationNumberCompany(kullaniciId);
      return (result as int?) ?? 0;
    } catch (e) {
      print('❌ API HATASI (candidateRegistrationNumberCompany): $e');
      return 0;
    }
  }

  // --- Atlanan Güncelleme Metotları ---

  /// Bir ilanı DTO kullanarak günceller.
  Future<bool> updateJob(Map<String, dynamic> requestBody) async {
    try {
      final result = await _api.updateJob(requestBody);
      return result != null;
    } catch (e) {
      print('❌ API HATASI (updateJob): $e');
      return false;
    }
  }

  // --- Driver License ve Foreign Languages Metotları --- /// İlanın sürücü belgesi listesini getirir.
  @override
  Future<dynamic> fetchJobDriverLicenseList(String ilanId) async {
    try {
      final result = await _api.fetchJobDriverLicenseList(ilanId);
      return result;
    } catch (e) {
      print('❌ API HATASI (fetchJobDriverLicenseList): $e');
      return null;
    }
  }

  /// İlanın yabancı dil listesini getirir.
  @override
  Future<dynamic> fetchJobForeignLanguagesList(String ilanId) async {
    try {
      final result = await _api.fetchJobForeignLanguagesList(ilanId);
      return result;
    } catch (e) {
      print('❌ API HATASI (fetchJobForeignLanguagesList): $e');
      return null;
    }
  }

  /// İlanın sürücü belgesi listesini günceller.
  @override
  Future<dynamic> updateJobDriverLicenseList(dynamic body) async {
    try {
      final result = await _api.updateJobDriverLicenseList(body);
      return result;
    } catch (e) {
      print('❌ API HATASI (updateJobDriverLicenseList): $e');
      return null;
    }
  }

  /// İlanın yabancı dil listesini günceller.
  @override
  Future<dynamic> updateJobForeignLanguagesList(dynamic body) async {
    try {
      final result = await _api.updateJobForeignLanguagesList(body);
      return result;
    } catch (e) {
      print('❌ API HATASI (updateJobForeignLanguagesList): $e');
      return null;
    }
  }
  
  @override
  Future fetchIlanKriter(String ilanId) {
    // TODO: implement fetchIlanKriter
    throw UnimplementedError();
  }
  
  @override
  Future fetchJobDetailById(String ilanId) {
    // TODO: implement fetchJobDetailById
    throw UnimplementedError();
  }
}
