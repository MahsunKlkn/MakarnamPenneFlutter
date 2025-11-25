import 'package:dio/dio.dart';
import '../../core/config/config.dart';
import 'base/BasePayment.dart';
import '../models/payment/Payment.dart';
import '../models/payment/PaymentInitiateRequest.dart';
import '../models/payment/PaymentInitiateResponse.dart';

Future<void> _handleErrorWithPopup(DioException error) async {
  print("API Hatası: ${error.message ?? 'Bilinmeyen hata'}");
  print("DioException: $error");
  print("DioException Type: ${error.type}");
  if (error.response != null) {
    print("Endpoint: ${error.requestOptions.path}");
    print("Hata Detayı: ${error.response?.data}");
    print("Durum Kodu: ${error.response?.statusCode}");
  }
}

class PaymentApiService implements BasePaymentApiService {
  final Dio _dio;
  final String _serviceUrl;

  PaymentApiService(this._dio) : _serviceUrl = '${AppConfig.instance.apiBaseUrl}/Payment';

  /// Ödeme başlatma
  @override
  Future<PaymentInitiateResponse?> initiatePayment(PaymentInitiateRequest request) async {
    try {
      print('💳 Payment Service: Ödeme başlatılıyor...');
      print('📍 Endpoint: $_serviceUrl/initiate');
      print('📦 Request Data: ${request.toJson()}');
      
      final response = await _dio.post('$_serviceUrl/initiate', data: request.toJson());
      
      print('✅ Response Status: ${response.statusCode}');
      print('📦 Response Data Type: ${response.data.runtimeType}');
      print('📦 Response Data: ${response.data}');
      
      if (response.data is Map<String, dynamic>) {
        return PaymentInitiateResponse.fromJson(response.data as Map<String, dynamic>);
      }
      // Eğer response farklı formatta gelirse deneme amaçlı map'e çevir
      if (response.data != null) {
        return PaymentInitiateResponse.fromJson(Map<String, dynamic>.from(response.data));
      }
      return null;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<PaymentModel?> getByConversationId(String conversationId) async {
    try {
      final response = await _dio.get('$_serviceUrl/conversation/$conversationId');
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        // API response might wrap data in { success: true, data: { ... } }
        if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
          return PaymentModel.fromJson(data['data'] as Map<String, dynamic>);
        }
        return PaymentModel.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<PaymentModel?> getByPaymentId(String paymentId) async {
    try {
      final response = await _dio.get('$_serviceUrl/payment/$paymentId');
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
          return PaymentModel.fromJson(data['data'] as Map<String, dynamic>);
        }
        return PaymentModel.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return null;
    }
  }

  @override
  Future<List<PaymentModel>> getByOrderId(int orderId) async {
    try {
      final response = await _dio.get('$_serviceUrl/order/$orderId');
      if (response.data is List) {
        return (response.data as List)
            .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('data') && data['data'] is List) {
          return (data['data'] as List)
              .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } on DioException catch (e) {
      await _handleErrorWithPopup(e);
      return [];
    }
  }
}
