import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../data/services/Payment.dart';
import '../../../../data/services/Product.dart';
import '../../../../data/models/payment/PaymentInitiateRequest.dart';
import '../../../../viewmodels/auth_view_model.dart';
import '../../../../viewmodels/basket_view_model.dart';
import '../../payment/payment_webview_screen.dart';

class ConfirmButton extends StatefulWidget {
  const ConfirmButton({super.key});

  @override
  State<ConfirmButton> createState() => _ConfirmButtonState();
}

class _ConfirmButtonState extends State<ConfirmButton> {
  bool _isProcessing = false;

  Future<void> _handlePayment() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final basketViewModel = Provider.of<BasketViewModel>(context, listen: false);

    if (!authViewModel.isLoggedIn || authViewModel.currentUserId == null) {
      _showError('Lütfen önce giriş yapın');
      return;
    }

    if (basketViewModel.userBasket == null || 
        basketViewModel.userBasket!.getProductIdsList().isEmpty) {
      _showError('Sepetiniz boş');
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final userId = int.parse(authViewModel.currentUserId!);
      final productIds = basketViewModel.userBasket!.getProductIdsList();
      final productService = locator<ProductApiService>();
      final paymentService = locator<PaymentApiService>();

      // Sepetteki ürünleri getir ve toplam fiyatı hesapla
      double totalPrice = 0.0;
      List<Map<String, dynamic>> basketItems = [];

      for (int productId in productIds) {
        final product = await productService.getProductById(productId);
        if (product != null) {
          double discountRate = ((product.discountRate ?? 0) / 100).clamp(0.0, 1.0);
          double finalPrice = product.price * (1 - discountRate);
          totalPrice += finalPrice;

          basketItems.add({
            'id': product.id.toString(),
            'name': product.name,
            'category1': product.categoryId.toString(),
            'itemType': 'PHYSICAL',
            'price': finalPrice,
          });
        }
      }

      if (basketItems.isEmpty) {
        _showError('Sepetteki ürünler yüklenemedi');
        setState(() => _isProcessing = false);
        return;
      }

      // Test için callback URL - production'da kendi domain'inizi kullanın
      // İyzico callback yapabilmesi için dışarıdan erişilebilir olmalı (ngrok vb.)
      const callbackUrl = 'https://your-backend-url.com/api/payment/callback';

      // Ödeme isteği oluştur
      // Not: basketId yerine 0 gönderiyoruz çünkü backend OrderId bekliyor olabilir
      final paymentRequest = PaymentInitiateRequest(
        price: totalPrice,
        paidPrice: totalPrice,
        currency: 'TRY',
        basketId: 0, // Backend OrderId nullable değilse geçici çözüm
        callbackUrl: callbackUrl,
        buyerId: userId.toString(),
        buyerName: 'Test', // Gerçek uygulamada kullanıcı bilgilerinden alın
        buyerSurname: 'Kullanıcı',
        buyerEmail: 'test@example.com',
        buyerIdentityNumber: '12345678901',
        buyerRegistrationAddress: 'Test Adres',
        buyerCity: 'Istanbul',
        buyerCountry: 'Turkey',
        buyerZipCode: '34000',
        buyerPhone: '+905551234567',
        shippingContactName: 'Test Kullanıcı',
        shippingCity: 'Istanbul',
        shippingCountry: 'Turkey',
        shippingAddress: 'Test Adres',
        shippingZipCode: '34000',
        billingContactName: 'Test Kullanıcı',
        billingCity: 'Istanbul',
        billingCountry: 'Turkey',
        billingAddress: 'Test Adres',
        billingZipCode: '34000',
        basketItems: basketItems,
      );

      print('💳 Ödeme başlatılıyor...');
      print('💰 Toplam: ${totalPrice.toStringAsFixed(2)} TL');
      print('🛍️ Ürün sayısı: ${basketItems.length}');
      print('📦 Basket ID: ${basketViewModel.userBasket!.id}');
      print('👤 User ID: $userId');

      final response = await paymentService.initiatePayment(paymentRequest);

      setState(() => _isProcessing = false);

      if (response == null) {
        _showError('Ödeme başlatılamadı - Backend\'den yanıt alınamadı. Lütfen console loglarını kontrol edin.');
        return;
      }

      if (!response.success) {
        final errorMsg = response.message ?? 'Bilinmeyen hata';
        print('❌ Backend hatası: $errorMsg');
        _showError('Ödeme başlatılamadı: $errorMsg');
        return;
      }

      if (response.threeDSHtmlContent == null) {
        _showError('Ödeme sayfası yüklenemedi');
        return;
      }

      print('✅ Ödeme sayfası alındı, WebView açılıyor...');
      print('📄 HTML Content uzunluğu: ${response.threeDSHtmlContent!.length}');
      print('🔍 HTML başlangıcı: ${response.threeDSHtmlContent!.substring(0, 100)}...');

      // WebView ile 3D Secure sayfasını göster
      if (!mounted) {
        print('❌ Widget mounted değil, WebView açılamıyor');
        return;
      }
      
      print('🚀 Navigator.push çağrılıyor...');
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentWebViewScreen(
            htmlContent: response.threeDSHtmlContent!,
            callbackUrl: callbackUrl,
          ),
        ),
      );

      print('🔙 WebView kapandı, result: $result');
      
      // Ödeme sonucunu kontrol et
      if (result == true) {
        print('🎉 Ödeme başarılı!');
        
        // Sepeti temizle
        print('🧹 Sepet temizleniyor...');
        final cleared = await basketViewModel.clearBasket(userId);
        
        if (cleared) {
          print('✅ Sepet başarıyla temizlendi');
          _showSuccess('Ödeme başarıyla tamamlandı! Sepetiniz temizlendi.');
        } else {
          print('⚠️ Sepet temizlenemedi ama ödeme başarılı');
          _showSuccess('Ödeme başarıyla tamamlandı!');
        }
      } else {
        print('❌ Ödeme iptal edildi veya başarısız');
      }

    } catch (e) {
      setState(() => _isProcessing = false);
      print('❌ Ödeme hatası: $e');
      _showError('Ödeme sırasında bir hata oluştu: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 0, 16, 16 + MediaQuery.of(context).padding.bottom),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange[700],
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: _isProcessing ? null : _handlePayment,
          child: _isProcessing
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Satın Al',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
        ),
      ),
    );
  }
}