 // lib/viewmodels/auth_view_model.dart
 import 'package:flutter/material.dart';
 import '../data/models/Token.dart';
 import '../data/models/Dto/DtoLogin.dart';
 import '../data/services/base/BaseLogin.dart';
 import '../repository/auth_repository.dart';
 import '../core/utils/role_menu_manager.dart';
 class AuthViewModel extends ChangeNotifier implements BaseAuthApiService {
   final AuthRepository _authRepository = AuthRepository();

   TokenModel? _currentUser;
   bool _isLoading = false;
   bool _isCheckingStatus = true;
   String? _errorMessage;
   // Getters
   bool get isLoggedIn => _currentUser != null;
   TokenModel? get currentUser => _currentUser;
   String? get currentUserId => _currentUser?.Id.toString();
   bool get isLoading => _isLoading;
   bool get isCheckingStatus => _isCheckingStatus;
   String? get errorMessage => _errorMessage;
   // Rol tabanlı menü getters
   UserRole? get currentUserRole => _currentUser != null 
       ? UserRole.fromId(_currentUser!.Rol) 
       : null;

   List<MenuItem> get userMenuItems => _currentUser != null 
       ? RoleMenuManager.getMenuItemsFromTokenRole(_currentUser!.Rol)
       : [];

   String get userHomeRoute => _currentUser != null
       ? RoleMenuManager.getHomeRouteFromTokenRole(_currentUser!.Rol)
       : '/home';
   AuthViewModel() {
     print('AuthViewModel: Başlatılıyor');
     _initializeAuth();
   }
   /// ViewModel başlatıldığında çalışır.
   Future<void> _initializeAuth() async {
     await checkAuthStatus();
   }
   /// Uygulama açıldığında depolanmış token'ı kontrol eder.
   Future<void> checkAuthStatus() async {
     print('AuthViewModel: Auth durumu kontrol ediliyor');
  
     _isCheckingStatus = true;
     _errorMessage = null;
     notifyListeners();
     try {
       _currentUser = await _authRepository.checkStoredToken();
       print('AuthViewModel: Auth durumu kontrol edildi - User: ${_currentUser?.Id}');
     } catch (e) {
       print('AuthViewModel: Auth durumu kontrol hatası - $e');
       _currentUser = null;
       _errorMessage = 'Oturum durumu kontrol edilemedi';
     }
     _isCheckingStatus = false;
     notifyListeners();
   }
   /// E-posta ve şifre ile giriş yapar.
   Future<bool> login(String email, String password) async {
     print('AuthViewModel: Giriş işlemi başlatılıyor - Email: $email');
  
     _isLoading = true;
     _errorMessage = null;
     notifyListeners();
     try {
       _currentUser = await _authRepository.login(email, password);
    
       final success = _currentUser != null;
       if (!success) {
         _errorMessage = 'Giriş işlemi başarısız. E-posta ve şifrenizi kontrol edin.';
       }
    
       print('AuthViewModel: Giriş işlemi tamamlandı - Success: $success');
    
       _isLoading = false;
       notifyListeners();
    
       return success;
     } catch (e) {
       print('AuthViewModel: Giriş hatası - $e');
       _errorMessage = 'Giriş işlemi sırasında bir hata oluştu.';
       _isLoading = false;
       notifyListeners();
       return false;
     }
   }
   /// Google ile giriş yapar.
   Future<bool> loginWithGoogle(Map<String, dynamic> googleUserDto) async {
     print('AuthViewModel: Google giriş işlemi başlatılıyor');
  
     _isLoading = true;
     _errorMessage = null;
     notifyListeners();
     try {
       _currentUser = await _authRepository.loginWithGoogle(googleUserDto);
    
       final success = _currentUser != null;
       if (!success) {
         _errorMessage = 'Google ile giriş başarısız oldu.';
       }
    
       print('AuthViewModel: Google giriş işlemi tamamlandı - Success: $success');
    
       _isLoading = false;
       notifyListeners();
    
       return success;
     } catch (e) {
       print('AuthViewModel: Google giriş hatası - $e');
       _errorMessage = 'Google giriş sırasında bir hata oluştu.';
       _isLoading = false;
       notifyListeners();
       return false;
     }
   }
   /// Session durumunu kontrol eder.
   Future<bool> validateSession() async {
     print('AuthViewModel: Session doğrulanıyor');
  
     try {
       final isValid = await _authRepository.checkSession();
    
       if (!isValid && _currentUser != null) {
         // Session geçersizse kullanıcıyı çıkar
         print('AuthViewModel: Session geçersiz, kullanıcı çıkarılıyor');
         await logout();
       }
    
       print('AuthViewModel: Session doğrulama tamamlandı - Valid: $isValid');
       return isValid;
     } catch (e) {
       print('AuthViewModel: Session doğrulama hatası - $e');
       return false;
     }
   }
   /// Oturumu sonlandırır.
   @override
   Future<bool> logout() async {
     print('AuthViewModel: Çıkış işlemi başlatılıyor');
  
     _isLoading = true;
     notifyListeners();
     try {
       final success = await _authRepository.logout();
       _currentUser = null;
       _errorMessage = null;
    
       print('AuthViewModel: Çıkış işlemi tamamlandı - Success: $success');
    
       _isLoading = false;
       notifyListeners();
       return success;
     } catch (e) {
       print('AuthViewModel: Çıkış hatası - $e');
       _errorMessage = 'Çıkış işlemi sırasında bir hata oluştu.';
       _isLoading = false;
       notifyListeners();
       return false;
     }
   }
   /// Hata mesajını temizler.
   void clearError() {
     _errorMessage = null;
     notifyListeners();
   }
   /// Manuel kullanıcı bilgisi güncelleme (profil güncellemesi sonrası vs.)
   void updateUser(TokenModel user) {
     print('AuthViewModel: Kullanici bilgileri guncelleniyor - User: ${user.Id}');
     _currentUser = user;
     notifyListeners();
   }
   /// Kullanıcının belirli bir rotaya erişim yetkisi olup olmadığını kontrol eder
   bool hasAccessToRoute(String routePath) {
     if (_currentUser == null) return false;
     return RoleMenuManager.hasAccessToRouteFromTokenRole(routePath, _currentUser!.Rol);
   }
   /// Kullanıcının belirli bir role sahip olup olmadığını kontrol eder
   bool hasRole(UserRole role) {
     if (_currentUser == null) return false;
     return UserRole.fromId(_currentUser!.Rol) == role;
   }
   /// Kullanıcının aday olup olmadığını kontrol eder
   bool get isCandidate => hasRole(UserRole.candidate);
   /// Kullanıcının işveren olup olmadığını kontrol eder
   bool get isEmployer => hasRole(UserRole.employer);
   /// Kullanıcının şirket yöneticisi olup olmadığını kontrol eder
   bool get isCompany => hasRole(UserRole.company);
   /// Debug için kullanıcının menü yapısını yazdırır
   void printUserMenuStructure() {
     if (currentUserRole != null) {
       RoleMenuManager.printMenuStructure(currentUserRole!);
     }
   }
   // BaseAuthApiService implementation - Repository'ye delegate ediyoruz

   @override
   Future<Map<String, dynamic>?> getToken(LoginDtoModel request) async {
     print('AuthViewModel: getToken çağrısı - Email: ${request.eposta}');
     return await _authRepository.getToken(request);
   }
   @override
   Future<bool> checkSession() async {
     print('AuthViewModel: checkSession çağrısı');
     return await _authRepository.checkSession();
   }
   @override
   Future<dynamic> loginOrRegisterWithGoogle(Map<String, dynamic> googleUserDto) async {
     print('AuthViewModel: loginOrRegisterWithGoogle çağrısı');
     return await _authRepository.loginOrRegisterWithGoogle(googleUserDto);
   }
 }