

 import '../../models/Dto/DtoLogin.dart';

abstract class BaseAuthApiService {
   Future<Map<String, dynamic>?> getToken(LoginDtoModel request);
   Future<bool> checkSession();
   Future<dynamic> loginOrRegisterWithGoogle(Map<String, dynamic> googleUserDto);
   Future<bool> logout();
 }