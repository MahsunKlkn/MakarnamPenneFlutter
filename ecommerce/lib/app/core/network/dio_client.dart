import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/config.dart';
import '../interceptors/auth_interceptor.dart';
//import '../interceptors/auth_interceptor.dart';

class DioClient {
  static Dio? _instance;
  
  static Dio get instance {
    if (_instance == null) {
      _instance = Dio(BaseOptions(
        baseUrl: AppConfig.instance.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));
      
      // SSL certificate bypass for development
      if (kDebugMode) {
        (_instance!.httpClientAdapter as dynamic).onHttpClientCreate = (HttpClient client) {
          client.badCertificateCallback = (cert, host, port) => true;
          return client;
        };
      }
      
      // Auth interceptor'ını ekle
      _instance!.interceptors.add(AuthInterceptor());
      
      // Debug modu için logging interceptor
      if (kDebugMode) {
        _instance!.interceptors.add(LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
        ));
      }
      
      print('🔧 DioClient - Global Dio instance oluşturuldu');
    }
    
    return _instance!;
  }
  
  static void reset() {
    _instance = null;
    print('🔄 DioClient - Instance reset edildi');
  }
}