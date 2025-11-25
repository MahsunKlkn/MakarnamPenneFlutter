import '../../models/payment/Payment.dart';
import '../../models/payment/PaymentInitiateRequest.dart';
import '../../models/payment/PaymentInitiateResponse.dart';

abstract class BasePaymentApiService {
  /// Ödeme başlatır (backend, Iyzico ile iletişime geçer)
  Future<PaymentInitiateResponse?> initiatePayment(PaymentInitiateRequest request);

  /// ConversationId ile ödeme bilgisini getirir
  Future<PaymentModel?> getByConversationId(String conversationId);

  /// PaymentId ile ödeme bilgisini getirir
  Future<PaymentModel?> getByPaymentId(String paymentId);

  /// OrderId'ye göre ödemeleri getirir
  Future<List<PaymentModel>> getByOrderId(int orderId);
}
