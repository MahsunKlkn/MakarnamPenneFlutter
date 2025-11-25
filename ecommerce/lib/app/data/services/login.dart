 // lib/data/services/auth_api_service.dart
 import 'package:dio/dio.dart';

 import '../../core/config/config.dart';
 import '../models/Dto/DtoLogin.dart';
import 'base/BaseLogin.dart';
 class AuthApiService implements BaseAuthApiService {
   final Dio _dio;
   final String _serviceUrl;
   AuthApiService(this._dio)
       : _serviceUrl = '${AppConfig.instance.apiBaseUrl}/Auth';
   
   
   @override // YENİ: Override anotasyonu eklendi
   Future<Map<String, dynamic>?> getToken(LoginDtoModel request) async {
     try {
       final response = await _dio.post(
         '$_serviceUrl/GetToken',
         data: request.toJson(),
         
       );
       // Cookie'yi alıp işleyelim - Header'dan Token'ı çekelim
       String? tokenCookie;
       if (response.headers.map.containsKey('set-cookie')) {
         final List<String> cookies = response.headers.map['set-cookie'] ?? [];
         for (String cookie in cookies) {
           if (cookie.startsWith('Token=')) {
             final int endIndex = cookie.indexOf(';');
             if (endIndex > 0) {
               tokenCookie = cookie.substring(6, endIndex);
             } else {
               tokenCookie = cookie.substring(6);
             }
             break;
           }
         }
       }
       if (tokenCookie != null) {
         Map<String, dynamic> result = {};
         if (response.data != null && response.data is Map) {
           result = (response.data as Map<String, dynamic>);
         }
         result['token'] = tokenCookie;
         return result;
       }
       if (response.data != null && response.data is Map) {
         return response.data as Map<String, dynamic>;
       }
    
       return null;
     } on DioException catch (e) {
       _handleError(e);
       return null;
     }
   }
   @override // YENİ: Override anotasyonu eklendi
   Future<bool> checkSession() async {
     try {
       final response = await _dio.get(
         '${AppConfig.instance.apiBaseUrl}/Hesabim/GetKullaniciProfil',
         
       );
       return response.statusCode == 200;
     } on DioException catch (e) {
       if (e.response?.statusCode != 401) {
         _handleError(e);
       }
       return false;
     }
   }
   @override // YENİ: Override anotasyonu eklendi
   Future<dynamic> loginOrRegisterWithGoogle(Map<String, dynamic> googleUserDto) async {
     try {
       final response = await _dio.post(
         '$_serviceUrl/GirisYadaKayitOlKullaniciGoogle',
         data: googleUserDto,
         
       );
       return response.data;
     } on DioException catch (e) {
       _handleError(e);
       return null;
     }
   }
   @override // YENİ: Override anotasyonu eklendi
   Future<bool> logout() async {
     try {
       await _dio.post(
         '$_serviceUrl/Logout',
         
       );
       return true;
     } on DioException catch (e) {
       _handleError(e);
       return false;
     }
   }
   // Bu metot private olduğu için base class'ta yer almaz.
   void _handleError(DioException error) {
     print("API Hatası: ${error.message}");
     if (error.response != null) {
       print("Endpoint: ${error.requestOptions.path}");
       print("Hata Detayı: ${error.response?.data}");
     }
   }
 }
 // Merkezi dio instance'ını kullanarak AuthApiService'i oluşturuyoruz.
