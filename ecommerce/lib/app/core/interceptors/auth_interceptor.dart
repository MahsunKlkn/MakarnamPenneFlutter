 import 'package:dio/dio.dart';
 import 'package:flutter_secure_storage/flutter_secure_storage.dart';
 class AuthInterceptor extends Interceptor {
   final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
   @override
   void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    
     
  
     // Token'ı al ve Authorization header'ına ekle
     final token = await _secureStorage.read(key: 'auth_token');
     if (token != null && token.isNotEmpty) {
       options.headers['Authorization'] = 'Bearer $token';
       print('🔐 AuthInterceptor - Token eklendi: Bearer ${token.substring(0, 20)}...');
     } else {
       print('⚠️ AuthInterceptor - Token bulunamadı!');
     }
  
     print('📤 Request Headers: ${options.headers}');
  
     super.onRequest(options, handler);
   }
   @override
   void onError(DioException err, ErrorInterceptorHandler handler) async {
     print('❌ AuthInterceptor - Error: ${err.response?.statusCode}');
  
     // 401 Unauthorized durumunda token'ı temizle
     if (err.response?.statusCode == 401) {
       print('🔒 401 Unauthorized - Token siliniyor...');
       await _secureStorage.delete(key: 'auth_token');
       // Burada kullanıcıyı login sayfasına yönlendirebilirsiniz
     }
  
     super.onError(err, handler);
   }
 }