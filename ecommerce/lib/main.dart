import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/common/root_shell/root_shell.dart';
import 'app/core/services/service_locator.dart';
import 'app/core/config/config.dart';
import 'app/viewmodels/auth_view_model.dart';
import 'app/viewmodels/basket_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // APK testi için Environment.test kullanın
  // Geliştirme için Environment.dev kullanın
  AppConfig.setup(Environment.test);
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => BasketViewModel()),
      ],
      child: MaterialApp(
        title: 'Makarnam Penne',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          scaffoldBackgroundColor: Colors.grey[100],
          fontFamily: 'Roboto', // Projenize uygun bir font ekleyebilirsiniz
        ),
        home: const MainShell(),
      ),
    );
  }
}

