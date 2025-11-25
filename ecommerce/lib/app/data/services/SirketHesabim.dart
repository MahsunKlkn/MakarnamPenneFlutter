// lib/services/sirket_api_service.dart

import 'package:dio/dio.dart';
import '../../core/config/config.dart';
import 'base/BaseSirket.dart';

Future<void> _handleErrorWithPopup(DioException error) async {
  print("API Hatası: ${error.message}");
  print("DioException: $error");
  if (error.response != null) {
    print("Endpoint: ${error.requestOptions.path}");
    print("Hata Detayı: ${error.response?.data}");
  }
}

class SirketApiService implements BaseSirketApiService {
  final Dio _dio;
  final String _serviceUrl;
  SirketApiService(this._dio)
      : _serviceUrl = '${AppConfig.instance.apiBaseUrl}/SirketHesabim';

  @override 
  Future<dynamic> mailGonderNotifications(String kullaniciId, String mailTip) async {
    try {
      final response = await _dio.post(
        '$_serviceUrl/MailGonderNotifications',
        data: {
          'kullaniciId': int.parse(kullaniciId),
          'mailTip': mailTip,
        },
      );
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override 
  Future<dynamic> fetchAllCompanies() async {
    try {
      final response = await _dio.get('$_serviceUrl/GetAllSirket');
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override 
  Future<dynamic> fetchCompanyById(String sirketId) async {
    try {
      final response = await _dio.get('$_serviceUrl/GetSirket/$sirketId');
      return response.data;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }
}