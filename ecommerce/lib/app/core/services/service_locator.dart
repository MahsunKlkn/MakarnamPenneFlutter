import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../data/services/Basket.dart';
import '../../data/services/Product.dart';
import '../../data/services/Category.dart';
import '../../data/services/Payment.dart';
import '../../data/services/SecureStorage.dart';
import '../../data/services/login.dart';
import '../../repository/BasketRepository.dart';
import '../network/dio_client.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Core
  locator.registerLazySingleton<Dio>(() => DioClient.instance);
  locator.registerLazySingleton<SecureStorageService>(() => SecureStorageService());

  // API services
  //locator.registerLazySingleton<IlanApiService>(() => IlanApiService(locator<Dio>()));
  locator.registerLazySingleton<AuthApiService>(() => AuthApiService(locator<Dio>()));
  //locator.registerLazySingleton<AdayHesabimApiService>(() => AdayHesabimApiService());
  locator.registerLazySingleton<ProductApiService>(() => ProductApiService(locator<Dio>()));
  locator.registerLazySingleton<CategoryApiService>(() => CategoryApiService(locator<Dio>()));
  locator.registerLazySingleton<BasketApiService>(() => BasketApiService(locator<Dio>()));
  locator.registerLazySingleton<PaymentApiService>(() => PaymentApiService(locator<Dio>()));
  
  // Repositories
  locator.registerLazySingleton<BasketRepository>(() => BasketRepository(locator<BasketApiService>()));
}
