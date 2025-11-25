// lib/services/ilan_api_service.dart

import 'package:dio/dio.dart';
import '../../core/utils/enum/advert-status.dart';
import '../../core/config/config.dart';
import 'base/BaseIlan.dart';

// Bu fonksiyon, JS kodundaki handleErrorWithPopup'in karşılığıdır.
// Projenizin ihtiyacına göre bir popup, snackbar vb. gösterecek şekilde doldurabilirsiniz.
Future<void> _handleErrorWithPopup(DioException error) async {
  // Geliştirme aşamasında hatayı konsola yazdırmak faydalıdır.
  print("API Hatası: ${error.message}");
  print("DioException: ${error}");
  print("DioException Type: ${error.type}");
  if (error.response != null) {
    print("Endpoint: ${error.requestOptions.path}");
    print("Hata Detayı: ${error.response?.data}");
  }
}

class IlanApiService implements BaseIlanApiService { // 'implements' ile base servisi uygula
  final Dio _dio;
  final String _serviceUrl;

  IlanApiService(this._dio)
      : _serviceUrl = '${AppConfig.instance.apiBaseUrl}/Jobs';

  @override
  Future<dynamic> totalAdvertCompany(String kullaniciId, String sirketId) async {
    try {
      final response = await _dio.post(
        '$_serviceUrl/GetIlanKayitSayisiCompany',
        data: {
          'SirketId': int.parse(sirketId),
          'Durum': -1,
          'CreatedBy': int.parse(kullaniciId),
        },
      );
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> totalDeleteAdvertCompany(String kullaniciId, String sirketId) async {
    try {
      final response = await _dio.post(
        '$_serviceUrl/GetDeleteIlanKayitSayisiCompany',
        data: {
          'SirketId': int.parse(sirketId),
          'Durum': -1,
          'CreatedBy': int.parse(kullaniciId),
        },
      );
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> fetchJobDetailById(String ilanId) async {
    try {
      final response = await _dio.get('$_serviceUrl/GetIlanDetay/$ilanId');
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }
  
  @override
  Future<dynamic> fetchJobById(String ilanId) async {
    try {
      final response = await _dio.get('$_serviceUrl/GetIlan/$ilanId');
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<bool?> hasIlanForPozisyon(String pozisyonId) async {
    try {
      final response = await _dio.get('$_serviceUrl/HasIlanForPozisyon/$pozisyonId');
      return response.data as bool?;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<bool?> hasIlanForSektor(String sektorId) async {
    try {
      final response = await _dio.get('$_serviceUrl/HasIlanForSektor/$sektorId');
      return response.data as bool?;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  Future<dynamic> _updateIlanDurum(String ilanId, IlanDurumu durum) async {
    try {
      final response = await _dio.post('$_serviceUrl/UpdateIlanDurum/$ilanId/${durum.value}');
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> deleteJob(String ilanId) => _updateIlanDurum(ilanId, IlanDurumu.silinmis);
  @override
  Future<dynamic> passiveJob(String ilanId) => _updateIlanDurum(ilanId, IlanDurumu.pasif);
  @override
  Future<dynamic> approveJob(String ilanId) => _updateIlanDurum(ilanId, IlanDurumu.aktif);
  @override
  Future<dynamic> rejectJob(String ilanId) => _updateIlanDurum(ilanId, IlanDurumu.onaylanmamis);

  @override
  Future<dynamic> fetchJobDriverLicenseList(String ilanId) async {
    try {
      final response = await _dio.get('$_serviceUrl/GetIlanSurucuBelgesiListe/$ilanId');
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> fetchJobForeignLanguagesList(String ilanId) async {
    try {
      final response = await _dio.get('$_serviceUrl/GetIlanYabanciDilListe/$ilanId');
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> fetchIlanKriter(String ilanId) async {
    try {
      final response = await _dio.get('$_serviceUrl/GetIlanKriter/$ilanId');
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> updateJobDriverLicenseList(dynamic body) async {
    try {
      final response = await _dio.post('$_serviceUrl/UpdateIlanSurucuBelgesiList', data: body);
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> updateJobForeignLanguagesList(dynamic body) async {
    try {
      final response = await _dio.post('$_serviceUrl/UpdateIlanYabanciDilList', data: body);
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> getIlanListe() async {
    try {
      final response = await _dio.post(
        '$_serviceUrl/GetIlanListe',
        data: {},
        options: Options(
          headers: {
            'TenantId': '1',
          },
        ),
      );
      if (response.statusCode != 200) {
        print('API Error: Non-200 status code: ${response.statusCode}');
        print('Response data: ${response.data}');
        return [];
      }
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      print('DioException in getIlanListe: ${e.message}');
      return [];
    } catch (e) {
      print('Unexpected error in getIlanListe: $e');
      return [];
    }
  }

  @override
  Future<dynamic> getIlanListeCompany(String sirketId) async {
    try {
      final response = await _dio.post(
        '$_serviceUrl/GetIlanListe',
        data: {'SirketId': int.parse(sirketId)},
      );
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> getCurrentUser() async {
    try {
      const url = "https://simurg.pro/gateway/services/identity/User/GetCurrentPersonDetail";
      final response = await _dio.get(url);
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> fetchUserById(String userId) async {
    try {
      final url = "https://simurg.pro/gateway/services/identity/User/GetCurrentPersonDetail/$userId";
      final response = await _dio.get(url);
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> getWaitingIlanListe() async {
    try {
      final response = await _dio.get('$_serviceUrl/GetWaitingIlanListe');
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<int?> getToplamIlan() async {
    try {
      final response = await _dio.post('$_serviceUrl/GetToplamIlanSayisiTenant');
      return response.data as int?;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }
  
  @override
  Future<int?> getAktifIlan() async {
    try {
      final response = await _dio.post('$_serviceUrl/GetAktifIlanSayisiTenant');
      return response.data as int?;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> getIlanCount() async {
    try {
      final response = await _dio.get('$_serviceUrl/GetIlanCountByTenantAndDurum');
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> fetchJobByIdNonAuth(String ilanId) async {
    try {
      final response = await _dio.get('$_serviceUrl/GetIlanById/$ilanId');
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> updateJob(Map<String, dynamic> requestBody) async {
    try {
      final response = await _dio.post('$_serviceUrl/CreateUpdateIlanDto', data: requestBody);
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> createUpdatePostJob(Map<String, dynamic> requestBody) async {
    try {
      final response = await _dio.post('$_serviceUrl/CreateUpdateIlan', data: requestBody);
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> sendStarRatings(Map<String, dynamic> ilanKriter) async {
    try {
      final response = await _dio.post('$_serviceUrl/CreateUpdateIlanKriter', data: ilanKriter);
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<int?> totalAdvert() async {
    try {
      final response = await _dio.post(
        '$_serviceUrl/GetIlanKayitSayisi',
        data: {'SirketId': -1, 'Durum': -1},
      );
      return response.data as int?;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<int?> activeAdvertCompany(String kullaniciId, String sirketId) async {
    try {
      final response = await _dio.post(
        '$_serviceUrl/GetAktifIlanKayitSayisiCompany',
        data: {
          'SirketId': int.parse(sirketId),
          'Durum': 1,
          'CreatedBy': int.parse(kullaniciId),
        },
      );
      return response.data as int?;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<int?> activeAdvert() async {
    try {
      final response = await _dio.post(
        '$_serviceUrl/GetIlanKayitSayisi',
        data: {'SirketId': -1, 'Durum': 1},
      );
      return response.data as int?;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> candidateRegistrationNumber() async {
    try {
      final response = await _dio.post(
        '$_serviceUrl/GetIlanKayitSayisi',
        data: {'SirketId': -1, 'Durum': -1, 'PasifNeden': -1},
      );
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<dynamic> candidateRegistrationNumberCompany(String kullaniciId) async {
    try {
      final response = await _dio.post(
        '$_serviceUrl/GetIlanKayitSayisiCompany',
        data: {
          'SirketId': -1,
          'Durum': -1,
          'PasifNeden': -1,
          'CreatedBy': int.parse(kullaniciId),
        },
      );
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<int?> getUnApprovedJobCount() async {
    try {
      final response = await _dio.get('$_serviceUrl/GetUnApprovedJobCount');
      return response.data as int?;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }
}
