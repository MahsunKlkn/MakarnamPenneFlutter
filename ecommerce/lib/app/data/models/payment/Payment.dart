class PaymentModel {
  final int? id;
  final int? orderId;
  final String? paymentId;
  final String? conversationId;
  final double? amount;
  final double? paidPrice;
  final String? currency;
  final String? status;
  final String? cardFamily;
  final String? cardType;
  final DateTime? paymentDate;

  PaymentModel({
    this.id,
    this.orderId,
    this.paymentId,
    this.conversationId,
    this.amount,
    this.paidPrice,
    this.currency,
    this.status,
    this.cardFamily,
    this.cardType,
    this.paymentDate,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? ''),
      orderId: json['orderId'] is int ? json['orderId'] as int : int.tryParse(json['orderId']?.toString() ?? ''),
      paymentId: json['paymentId']?.toString(),
      conversationId: json['conversationId']?.toString(),
      amount: (json['amount'] is num) ? (json['amount'] as num).toDouble() : double.tryParse(json['amount']?.toString() ?? ''),
      paidPrice: (json['paidPrice'] is num) ? (json['paidPrice'] as num).toDouble() : double.tryParse(json['paidPrice']?.toString() ?? ''),
      currency: json['currency']?.toString(),
      status: json['status']?.toString(),
      cardFamily: json['cardFamily']?.toString(),
      cardType: json['cardType']?.toString(),
      paymentDate: json['paymentDate'] != null ? DateTime.tryParse(json['paymentDate'].toString()) : null,
    );
  }
}
