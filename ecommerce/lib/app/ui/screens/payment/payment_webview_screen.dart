import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String htmlContent;
  final String callbackUrl;

  const PaymentWebViewScreen({
    super.key,
    required this.htmlContent,
    required this.callbackUrl,
  });

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    // İyzico HTML'ini wrapper ile sarmalayalım
    final wrappedHtml = '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>İyzico Ödeme</title>
</head>
<body>
    <div id="iyzipay-checkout-form" class="responsive"></div>
    ${widget.htmlContent}
</body>
</html>
''';

    print('📄 Wrapped HTML uzunluğu: ${wrappedHtml.length}');

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            print('🌐 WebView: Sayfa yükleniyor - $url');
            setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            print('✅ WebView: Sayfa yüklendi - $url');
            setState(() => _isLoading = false);

            // Callback URL'ine yönlendirme yapıldıysa ödeme tamamlandı demektir
            if (url.contains('/api/payment/callback') || 
                url.contains(widget.callbackUrl)) {
              print('🎉 Ödeme callback yakalandı!');
              _handlePaymentComplete(success: true);
            }
          },
          onWebResourceError: (error) {
            print('❌ WebView Hatası: ${error.description}');
          },
          onNavigationRequest: (request) {
            print('📍 Navigation Request: ${request.url}');
            
            // Callback URL kontrolü
            if (request.url.contains('/api/payment/callback') || 
                request.url.contains(widget.callbackUrl)) {
              print('🎯 Callback URL yakalandı!');
              _handlePaymentComplete(success: true);
              return NavigationDecision.prevent;
            }
            
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString(
        wrappedHtml,
        baseUrl: 'https://sandbox-api.iyzipay.com',
      );
  }

  void _handlePaymentComplete({required bool success}) {
    // Önceden pop edilmişse tekrar etmeyelim
    if (!mounted) return;
    
    Navigator.pop(context, success);
    
    // Kullanıcıya bilgi göster
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? '✅ Ödeme başarılı!' : '❌ Ödeme başarısız'),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Güvenli Ödeme'),
        backgroundColor: Colors.orange[700],
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Kullanıcı ödemeyi iptal etti
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Ödeme İptali'),
                content: const Text('Ödeme işlemini iptal etmek istediğinizden emin misiniz?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Hayır'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx); // Dialog'u kapat
                      Navigator.pop(context, false); // WebView ekranını kapat
                    },
                    child: const Text('Evet, İptal Et'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Ödeme sayfası yükleniyor...'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
