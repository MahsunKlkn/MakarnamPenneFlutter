 // dart_jsonwebtoken kaldırıldı, jwt_decoder eklendi
 import 'package:jwt_decoder/jwt_decoder.dart';
 import 'api_service_provider.dart';
 // Bu sınıfın artık KullaniciModel'e doğrudan bağımlılığı yok,
 // sadece ham Map<String, dynamic> döndürüyor.
 class TokenService {

   static Future<Map<String, dynamic>?> getPayloadFromToken() async {
     final String? token = await secureStorageService.getToken();
     if (token == null) return null;
     try {
       // 1. Önce token'ın süresinin dolup dolmadığını kontrol et
       final bool isExpired = JwtDecoder.isExpired(token);
       if (isExpired) {
         print("JWT'nin süresi dolmuş!");
         await secureStorageService.deleteToken(); // Süresi dolanı sil
         return null;
       }
       // 2. Süresi dolmamışsa, içeriğini oku (decode et)
       final Map<String, dynamic> payload = JwtDecoder.decode(token);
    
       // 3. Payload'ı döndür
       return payload;
     } catch (e) {
       // Token bozuk veya decode edilemezse hata verir.
       print('Token decode edilirken hata oluştu: $e');
       await secureStorageService.deleteToken(); // Bozuk token'ı sil
       return null;
     }
   }
 }