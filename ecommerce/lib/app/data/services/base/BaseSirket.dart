// lib/services/base/base_sirket_api_service.dart

abstract class BaseSirketApiService {
  Future<dynamic> mailGonderNotifications(String kullaniciId, String mailTip);
  Future<dynamic> fetchAllCompanies();
  Future<dynamic> fetchCompanyById(String sirketId);
}