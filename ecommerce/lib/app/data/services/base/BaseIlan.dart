// lib/services/base/base_ilan_api_service.dart
abstract class BaseIlanApiService {
  Future<dynamic> totalAdvertCompany(String kullaniciId, String sirketId);
  Future<dynamic> totalDeleteAdvertCompany(String kullaniciId, String sirketId);
  Future<dynamic> fetchJobDetailById(String ilanId);
  Future<dynamic> fetchJobById(String ilanId);
  Future<bool?> hasIlanForPozisyon(String pozisyonId);
  Future<bool?> hasIlanForSektor(String sektorId);
  Future<dynamic> deleteJob(String ilanId);
  Future<dynamic> passiveJob(String ilanId);
  Future<dynamic> approveJob(String ilanId);
  Future<dynamic> rejectJob(String ilanId);
  Future<dynamic> fetchJobDriverLicenseList(String ilanId);
  Future<dynamic> fetchJobForeignLanguagesList(String ilanId);
  Future<dynamic> fetchIlanKriter(String ilanId);
  Future<dynamic> updateJobDriverLicenseList(dynamic body);
  Future<dynamic> updateJobForeignLanguagesList(dynamic body);
  Future<dynamic> getIlanListe();
  Future<dynamic> getIlanListeCompany(String sirketId);
  Future<dynamic> getCurrentUser();
  Future<dynamic> fetchUserById(String userId);
  Future<dynamic> getWaitingIlanListe();
  Future<int?> getToplamIlan();
  Future<int?> getAktifIlan();
  Future<dynamic> getIlanCount();
  Future<dynamic> fetchJobByIdNonAuth(String ilanId);
  Future<dynamic> updateJob(Map<String, dynamic> requestBody);
  Future<dynamic> createUpdatePostJob(Map<String, dynamic> requestBody);
  Future<dynamic> sendStarRatings(Map<String, dynamic> ilanKriter);
  Future<int?> totalAdvert();
  Future<int?> activeAdvertCompany(String kullaniciId, String sirketId);
  Future<int?> activeAdvert();
  Future<dynamic> candidateRegistrationNumber();
  Future<dynamic> candidateRegistrationNumberCompany(String kullaniciId);
  Future<int?> getUnApprovedJobCount();
}