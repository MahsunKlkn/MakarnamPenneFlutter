 // lib/repository/auth_repository.dart
 import '../core/services/api_service_provider.dart';
 import '../core/services/token_service.dart';
 import '../data/models/Dto/DtoLogin.dart';
 import '../data/models/Token.dart';
 import '../data/services/base/BaseLogin.dart';
 class AuthRepository implements BaseAuthApiService {
   /// E-posta ve şifre ile giriş yapmayı dener.
   Future<TokenModel?> login(String email, String password) async {
     try {
       print('AuthRepository: Giriş işlemi başlatılıyor - Email: $email');
    
       final loginDto = LoginDtoModel(
         eposta: email,
         sifre: password,

       );
    
       // API'den token'ı alıyoruz
       final Map<String, dynamic>? result = await authApiService.getToken(loginDto);
    
       print('AuthRepository: API yanıtı alındı - Result: $result');
    
       if (result != null && result['token'] is String) {
         final String token = result['token'];
      
         print('AuthRepository: Token alındı, güvenli depoya kaydediliyor');
      
         // Token'ı güvenli depoya kaydet
         await secureStorageService.saveToken(token);
      
         // Token'dan kullanıcı bilgilerini al
         final payload = await TokenService.getPayloadFromToken();
         if (payload != null) {
           final user = TokenModel.fromPayload(payload);
           print('AuthRepository: Kullanici bilgileri yuklendi - User: ${user.Id}');
           return user;
         } else {
           print('AuthRepository: Token payload alinamadi');
           return null;
         }
       } else {
         print('AuthRepository: API yanıtında token bulunamadı');
         return null;
       }
     } catch (e) {
       print('AuthRepository: Giriş hatası - $e');
       return null;
     }
   }
   /// Depolanmış token'ı kontrol eder ve kullanıcı bilgilerini döndürür.
   Future<TokenModel?> checkStoredToken() async {
     try {
       print('AuthRepository: Depolanmış token kontrol ediliyor');
    
       final payload = await TokenService.getPayloadFromToken();
       if (payload != null) {
         final user = TokenModel.fromPayload(payload);
         print('AuthRepository: Depolanan token gecerli - User: ${user.Id}');
         return user;
       } else {
         print('AuthRepository: Depolanmış token bulunamadı veya geçersiz');
         return null;
       }
     } catch (e) {
       print('AuthRepository: Token kontrol hatası - $e');
       return null;
     }
   }
   /// Session durumunu API'den kontrol eder.
   @override
   Future<bool> checkSession() async {
     try {
       print('AuthRepository: Session durumu kontrol ediliyor');
    
       final isValid = await authApiService.checkSession();
    
       print('AuthRepository: Session durumu - Valid: $isValid');
       return isValid;
     } catch (e) {
       print('AuthRepository: Session kontrol hatası - $e');
       return false;
     }
   }
   /// Oturumu sonlandırır ve token'ı siler.
   @override
   Future<bool> logout() async {
     try {
       print('AuthRepository: Çıkış işlemi başlatılıyor');
    
       // API'da oturumu sonlandır
       final success = await authApiService.logout();
    
       // Token'ı güvenli depodan sil
       await secureStorageService.deleteToken();
    
       print('AuthRepository: Çıkış işlemi tamamlandı - Success: $success');
       return success;
     } catch (e) {
       print('AuthRepository: Çıkış hatası - $e');
       return false;
     }
   }
   /// Google ile giriş/kayıt işlemi.
   Future<TokenModel?> loginWithGoogle(Map<String, dynamic> googleUserDto) async {
     try {
       print('AuthRepository: Google giriş işlemi başlatılıyor');
    
       final result = await authApiService.loginOrRegisterWithGoogle(googleUserDto);
    
       print('AuthRepository: Google API yanıtı - Result: $result');
    
       if (result != null && result['token'] is String) {
         final String token = result['token'];
      
         // Token'ı güvenli depoya kaydet
         await secureStorageService.saveToken(token);
      
         // Token'dan kullanıcı bilgilerini al
         final payload = await TokenService.getPayloadFromToken();
         if (payload != null) {
           final user = TokenModel.fromPayload(payload);
           print('AuthRepository: Google giris basarili - User: ${user.Id}');
           return user;
         }
       }
    
       print('AuthRepository: Google giriş başarısız');
       return null;
     } catch (e) {
       print('AuthRepository: Google giriş hatası - $e');
       return null;
     }
   }
   // BaseAuthApiService implementation
   @override
   Future<Map<String, dynamic>?> getToken(LoginDtoModel request) async {
     try {
       print('AuthRepository: getToken çağrısı - Email: ${request.eposta}');
       return await authApiService.getToken(request);
     } catch (e) {
       print('AuthRepository: getToken hatası - $e');
       return null;
     }
   }
   @override
   Future<dynamic> loginOrRegisterWithGoogle(Map<String, dynamic> googleUserDto) async {
     try {
       print('AuthRepository: loginOrRegisterWithGoogle çağrısı');
       return await authApiService.loginOrRegisterWithGoogle(googleUserDto);
     } catch (e) {
       print('AuthRepository: loginOrRegisterWithGoogle hatası - $e');
       return null;
     }
   }
 }