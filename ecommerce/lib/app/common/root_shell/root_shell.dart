import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ui/screens/account/index.dart';
import '../../ui/screens/employer-dashboard/product-manager/index.dart';
import '../../ui/screens/home/index.dart';
import '../../ui/screens/menu/index.dart';
import '../../viewmodels/auth_view_model.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  List<Widget> _getPages(AuthViewModel authViewModel) {
    final List<Widget> pages = [
      const HomePage(),
    ];

    // Kullanıcı giriş yapmışsa rol kontrolü yap
    if (authViewModel.isLoggedIn && authViewModel.currentUser != null) {
      final userRole = authViewModel.currentUser!.Rol;
      
      if (userRole == 1) {
        pages.add(const MenuPage());
      } else if (userRole == 2) {
        pages.add(const ProductManagerPage());
      }
    } else {
      // Kullanıcı giriş yapmamışsa varsayılan olarak MenuPage göster
      pages.add(const MenuPage());
    }

    pages.add(MyAccount());
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        final pages = _getPages(authViewModel);
        
        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
          bottomNavigationBar: Container( // NavigationBar'ı bir Container içine aldık
            decoration: BoxDecoration(
              color: Colors.white, // NavigationBar'ın kendi arka planı da beyaz olmalı
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3), // Gölgenin rengi ve opaklığı
                  spreadRadius: 1, // Gölgenin yayılma yarıçapı
                  blurRadius: 10, // Gölgenin bulanıklık yarıçapı
                  offset: const Offset(0, -3), // Gölgenin konumu (y ekseninde yukarı doğru)
                ),
              ],
            ),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                backgroundColor: Colors.white, // Arka plan rengi beyaz (Container ile çakışmaması için burada da belirtmek iyi olur)
                indicatorColor: Colors.grey.shade200, // İndikatörün rengi açık gri
                iconTheme: MaterialStateProperty.resolveWith((states) {
                  // Seçili durumda turuncu, değilse koyu gri
                  return states.contains(MaterialState.selected)
                      ? const IconThemeData(color: Colors.deepOrange) // Orange yerine deepOrange tercih ettim, MenuPage ile uyumlu
                      : const IconThemeData(color: Colors.grey);
                }),
                labelTextStyle: MaterialStateProperty.resolveWith((states) {
                  // Seçili durumda turuncu, değilse koyu gri
                  return states.contains(MaterialState.selected)
                      ? const TextStyle(
                          color: Colors.deepOrange, // Orange yerine deepOrange tercih ettim
                          fontWeight: FontWeight.bold)
                      : const TextStyle(color: Colors.grey);
                }),
              ),
              child: NavigationBar(
                selectedIndex: _currentIndex,
                onDestinationSelected: (index) {
                  setState(() => _currentIndex = index);
                },
                destinations: _getNavigationDestinations(authViewModel),
              ),
            ),
          ),
        );
      },
    );
  }

  List<NavigationDestination> _getNavigationDestinations(AuthViewModel authViewModel) {
    final List<NavigationDestination> destinations = [
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home),
        label: 'Ana Sayfa',
      ),
    ];

    // Kullanıcı giriş yapmışsa rol kontrolü yap
    if (authViewModel.isLoggedIn && authViewModel.currentUser != null) {
      final userRole = authViewModel.currentUser!.Rol;
      
      if (userRole == 1) {
        destinations.add(
          const NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Menü',
          ),
        );
      } else if (userRole == 2) {
        destinations.add(
          const NavigationDestination(
            icon: Icon(Icons.inventory_outlined),
            selectedIcon: Icon(Icons.inventory),
            label: 'Ürün Yönetimi',
          ),
        );
      }
    } else {
      // Kullanıcı giriş yapmamışsa varsayılan olarak Menü göster
      destinations.add(
        const NavigationDestination(
          icon: Icon(Icons.menu_book_outlined),
          selectedIcon: Icon(Icons.menu_book),
          label: 'Menü',
        ),
      );
    }

    destinations.add(
      const NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings),
        label: 'Ayarlar',
      ),
    );

    return destinations;
  }
}