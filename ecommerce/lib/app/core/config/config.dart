// lib/core/config/config.dart

import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'dart:io' show Platform;

/// Uygulamanın çalıştığı ortamı belirtir.
enum Environment {
  /// Geliştirme ortamı.
  dev,
  /// Test/Staging ortamı (Render API).
  test,
  /// Canlı (prodüksiyon) ortamı.
  prod,
}

/// Uygulama genelindeki ağ ve ortam yapılandırmalarını yönetir.
///
/// Kullanım:
/// 1. main() fonksiyonunda `AppConfig.setup(Environment.dev)` çağrılmalıdır.
/// 2. API servislerinde `AppConfig.instance.apiBaseUrl` üzerinden erişilir.
final class AppConfig {
  /// Ayarlanan API temel URL'sini tutar.
  late final String apiBaseUrl;



  // --- Özel Ayarlar ---

  static const int _httpPort = 5118; // HTTP port ayarı
  static const int _httpsPort = 7197; // HTTPS port ayarı

  // Backend'iniz HTTPS kullandığı için bunu 'true' yapın
  static const bool _useHttpsInDev = true; // HTTPS kullanıldığında true olmalı


  // --- Singleton Yapısı ---

  // Singleton instance'ı. Uygulama boyunca tek bir AppConfig nesnesi olmasını sağlar.
  static final AppConfig instance = AppConfig._internal();

  // Özel kurucu metot. Dışarıdan yeni nesne oluşturulmasını engeller.
  AppConfig._internal();

  /// Yapılandırmayı belirtilen ortama göre başlatır.
  /// Bu metot, uygulama başlamadan önce `main()` içinde çağrılmalıdır.
  static void setup(Environment environment) {
    instance.apiBaseUrl = _getBaseUrl(environment);
    // Geliştirme sırasında hangi URL'nin kullanıldığını görmek için loglama.
    if (kDebugMode) {
      print('✅ API Base URL Ayarlandı: ${instance.apiBaseUrl}');
    }
  }

  /// Ortama ve platforma göre doğru API temel URL'sini oluşturan özel metot.
  static String _getBaseUrl(Environment environment) {
    // 1. Canlı (Prod) Ortamı
    if (environment == Environment.prod) {
      return 'https://mhsnkalkan.com/api';
    }

    // 2. Test/Staging Ortamı (Render API)
    if (environment == Environment.test) {
      return 'https://ecommerceapi-86fp.onrender.com/api';
    }

    // 3. Geliştirme (Dev) Ortamı
    final protocol = _useHttpsInDev ? 'https' : 'http';
    final port = _useHttpsInDev ? _httpsPort : _httpPort;
    final portSuffix = (port == 80 && !_useHttpsInDev) || (port == 443 && _useHttpsInDev)
        ? ''
        : ':$port';

    // Platforma özel IP/host adresi belirleme
    String host;
    if (kIsWeb) {
      // Web platformunda her zaman 'localhost' kullanılır.
      host = 'localhost';
    } else {
      // Mobil veya Masaüstü platformları
      // `dart:io` paketi web'de desteklenmediği için bu kontrol `kIsWeb`'den sonradır.
      if (Platform.isAndroid) {
        // Android emülatörü, bilgisayarın localhost'una '10.0.2.2' adresiyle erişir.
        host = '10.0.2.2';
      } else {
        // iOS simülatörü ve masaüstü platformları doğrudan 'localhost' kullanabilir.
        host = 'localhost';
      }
    }

    return '$protocol://$host$portSuffix/api';
  }
}