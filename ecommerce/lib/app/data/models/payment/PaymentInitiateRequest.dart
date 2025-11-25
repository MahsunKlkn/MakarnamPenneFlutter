class PaymentInitiateRequest {
  final double price;
  final double paidPrice;
  final String currency;
  final int basketId;
  final String callbackUrl;

  // Buyer
  final String buyerId;
  final String buyerName;
  final String buyerSurname;
  final String buyerEmail;
  final String buyerIdentityNumber;
  final String buyerRegistrationAddress;
  final String buyerCity;
  final String buyerCountry;
  final String buyerZipCode;
  final String buyerPhone;

  // Shipping
  final String shippingContactName;
  final String shippingCity;
  final String shippingCountry;
  final String shippingAddress;
  final String shippingZipCode;

  // Billing
  final String billingContactName;
  final String billingCity;
  final String billingCountry;
  final String billingAddress;
  final String billingZipCode;

  // Basket items simplified
  final List<Map<String, dynamic>> basketItems;

  PaymentInitiateRequest({
    required this.price,
    required this.paidPrice,
    required this.currency,
    required this.basketId,
    required this.callbackUrl,
    required this.buyerId,
    required this.buyerName,
    required this.buyerSurname,
    required this.buyerEmail,
    required this.buyerIdentityNumber,
    required this.buyerRegistrationAddress,
    required this.buyerCity,
    required this.buyerCountry,
    required this.buyerZipCode,
    required this.buyerPhone,
    required this.shippingContactName,
    required this.shippingCity,
    required this.shippingCountry,
    required this.shippingAddress,
    required this.shippingZipCode,
    required this.billingContactName,
    required this.billingCity,
    required this.billingCountry,
    required this.billingAddress,
    required this.billingZipCode,
    required this.basketItems,
  });

  Map<String, dynamic> toJson() => {
        'price': price,
        'paidPrice': paidPrice,
        'currency': currency,
        'basketId': basketId,
        'callbackUrl': callbackUrl,
        'buyerId': buyerId,
        'buyerName': buyerName,
        'buyerSurname': buyerSurname,
        'buyerEmail': buyerEmail,
        'buyerIdentityNumber': buyerIdentityNumber,
        'buyerRegistrationAddress': buyerRegistrationAddress,
        'buyerCity': buyerCity,
        'buyerCountry': buyerCountry,
        'buyerZipCode': buyerZipCode,
        'buyerPhone': buyerPhone,
        'shippingContactName': shippingContactName,
        'shippingCity': shippingCity,
        'shippingCountry': shippingCountry,
        'shippingAddress': shippingAddress,
        'shippingZipCode': shippingZipCode,
        'billingContactName': billingContactName,
        'billingCity': billingCity,
        'billingCountry': billingCountry,
        'billingAddress': billingAddress,
        'billingZipCode': billingZipCode,
        'basketItems': basketItems,
      };
}
