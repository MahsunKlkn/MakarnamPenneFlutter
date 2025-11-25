class PaymentInitiateResponse {
  final bool success;
  final String? message;
  final String? threeDSHtmlContent;
  final String? paymentId;
  final String? conversationId;

  PaymentInitiateResponse({
    required this.success,
    this.message,
    this.threeDSHtmlContent,
    this.paymentId,
    this.conversationId,
  });

  factory PaymentInitiateResponse.fromJson(Map<String, dynamic> json) {
    return PaymentInitiateResponse(
      success: json['success'] == true || json['success'].toString() == 'true',
      message: json['message']?.toString(),
      threeDSHtmlContent: json['threeDSHtmlContent']?.toString(),
      paymentId: json['paymentId']?.toString(),
      conversationId: json['conversationId']?.toString(),
    );
  }
}
