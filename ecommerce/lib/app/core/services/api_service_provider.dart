import 'package:dio/dio.dart';
import '../../data/services/Product.dart';
import '../../data/services/Category.dart';
import '../../data/services/SecureStorage.dart';
import '../../data/services/login.dart';
import 'service_locator.dart';

// Locator üzerinden resolve edilen servisler
Dio get dio => locator<Dio>();
//IlanApiService get ilanApiService => locator<IlanApiService>();
AuthApiService get authApiService => locator<AuthApiService>();
//AdayHesabimApiService get adayHesabimApiService => locator<AdayHesabimApiService>();
SecureStorageService get secureStorageService => locator<SecureStorageService>();
ProductApiService get productApiService => locator<ProductApiService>();
CategoryApiService get categoryApiService => locator<CategoryApiService>();
