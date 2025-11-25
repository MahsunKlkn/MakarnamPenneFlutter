// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../ui/screens/home/index.dart';
// import '../../ui/screens/home/widgets/LoginDialog.dart';

// import '../../viewmodels/auth_view_model.dart';
// import '../../core/utils/role_menu_manager.dart';



// class CustomDrawer extends StatelessWidget {
//   const CustomDrawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // AuthViewModel'i dinleyerek menünün dinamik olmasını sağlıyoruz
//     final authState = context.watch<AuthViewModel>();

//     return Drawer(
//       elevation: 8,
//       child: Container(
//         color: Colors.white,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // --- 1. Üst Kısım (Header) ---
//             _buildDrawerHeader(context, authState),

//             // --- 2. Menü Elemanları ---
//             Expanded(
//               child: _buildMenuItems(context, authState),
//             ),

//             // --- 3. Alt Kısım (Footer) ---
//             _buildDrawerFooter(context, authState),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Menünün üst kısmını (Header) oluşturan metot.
//   /// Kullanıcı giriş yapmışsa profil bilgisi, yapmamışsa giriş butonu gösterir.
//   Widget _buildDrawerHeader(BuildContext context, AuthViewModel authState) {
//     return Container(
//       padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFF03448D), Color(0xFF02356e)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: authState.isLoggedIn && authState.currentUser != null
//           ? Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const CircleAvatar(
//                   radius: 35,
//                   backgroundColor: Colors.white,
//                   child: Icon(Icons.person, size: 40, color: Color(0xFF03448D)),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   '${authState.currentUser!.Ad ?? ''} ${authState.currentUser!.Soyad ?? ''}',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   authState.currentUser!.Eposta ?? '',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.8),
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 // Rol badge'i ekle
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: _getRoleColor(authState.currentUserRole),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     authState.currentUserRole?.displayName ?? 'Bilinmeyen',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           : Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Icon(Icons.login, color: Colors.white, size: 50),
//                 const SizedBox(height: 12),
//                 const Text(
//                   'Hoş Geldiniz',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Tüm özellikleri kullanmak için giriş yapın.',
//                   style: TextStyle(color: Colors.white.withOpacity(0.8)),
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context); // Menüyü kapat
//                     showDialog(
//                         context: context,
//                         builder: (_) => const LoginDialog());
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: const Color(0xFF03448D),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text('Giriş Yap / Kayıt Ol'),
//                 )
//               ],
//             ),
//     );
//   }

//   /// Rol için renk dönen metot
//   Color _getRoleColor(UserRole? role) {
//     switch (role) {
//       case UserRole.candidate:
//         return Colors.green;
//       case UserRole.employer:
//         return Colors.orange;
//       case UserRole.company:
//         return Colors.blue;
//       default:
//         return Colors.grey;
//     }
//   }

//   /// Menüdeki sayfa linklerini oluşturan metot.
//   Widget _buildMenuItems(BuildContext context, AuthViewModel authState) {
//     if (!authState.isLoggedIn) {
//       // Giriş yapmamış kullanıcılar için basit menü
//       return Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             _buildMenuItem(
//               context,
//               icon: Icons.home_outlined,
//               text: 'Ana Sayfa',
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const MyHomePage()),
//                 );
//               },
//             ),
//             _buildMenuItem(
//               context,
//               icon: Icons.work_outline,
//               text: 'İş İlanları',
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const IlanListPage()),
//                 );
//               },
//             ),
//           ],
//         ),
//       );
//     }

//     // Giriş yapmış kullanıcılar için rol tabanlı menü
//     final userMenuItems = authState.userMenuItems;
    
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: ListView.builder(
//         itemCount: userMenuItems.length,
//         itemBuilder: (context, index) {
//           final menuItem = userMenuItems[index];
//           return _buildRoleBasedMenuItem(context, menuItem);
//         },
//       ),
//     );
//   }

//   /// Rol tabanlı menü item'ı oluşturan metot
//   Widget _buildRoleBasedMenuItem(BuildContext context, MenuItem menuItem) {
//     if (menuItem.subMenu != null && menuItem.subMenu!.isNotEmpty) {
//       return ExpansionTile(
//         leading: Icon(_getIconData(menuItem.icon)),
//         title: Text(menuItem.name),
//         children: menuItem.subMenu!
//             .map((subItem) => Padding(
//                   padding: const EdgeInsets.only(left: 16),
//                   child: _buildMenuItem(
//                     context,
//                     icon: _getIconData(subItem.icon),
//                     text: subItem.name,
//                     onTap: () => _navigateToRoute(context, subItem.routePath),
//                   ),
//                 ))
//             .toList(),
//       );
//     } else {
//       return _buildMenuItem(
//         context,
//         icon: _getIconData(menuItem.icon),
//         text: menuItem.name,
//         onTap: () => _navigateToRoute(context, menuItem.routePath),
//       );
//     }
//   }

//   /// Icon class string'ini IconData'ya çeviren metot
//   IconData _getIconData(String iconClass) {
//     switch (iconClass) {
//       case 'la-home':
//         return Icons.home_outlined;
//       case 'la-paper-plane':
//         return Icons.send_outlined;
//       case 'la-briefcase':
//         return Icons.work_outline;
//       case 'la-bullhorn':
//         return Icons.campaign_outlined;
//       case 'la-plus':
//         return Icons.add;
//       case 'la-list':
//         return Icons.list;
//       case 'la-edit':
//         return Icons.edit_outlined;
//       case 'la-address-book':
//         return Icons.contacts_outlined;
//       case 'la-file-invoice':
//         return Icons.description_outlined;
//       case 'la-user':
//         return Icons.person_outline;
//       case 'la-file-pdf':
//         return Icons.picture_as_pdf_outlined;
//       case 'la-users':
//         return Icons.group_outlined;
//       case 'la-building':
//         return Icons.business_outlined;
//       case 'la-chart-bar':
//         return Icons.bar_chart_outlined;
//       case 'la-cog':
//         return Icons.settings_outlined;
//       case 'la-question-circle':
//         return Icons.help_outline;
//       default:
//         return Icons.circle_outlined;
//     }
//   }

//   /// Route'a navigasyon yapan metot
//   void _navigateToRoute(BuildContext context, String routePath) {
//     if (routePath == '#') return; // Placeholder route'lar için
    
//     Navigator.pop(context); // Drawer'ı kapat
    
//     // Ana sayfa route'ları için özel navigasyon
//     if (routePath == '/home') {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const MyHomePage()),
//       );
//     } else if (routePath == '/jobs') {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const MyHomePage()),
//       );
//     } else if (routePath == '/candidates-dashboard/applied-jobs') {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const MyHomePage()),
//       );
//     } else {
//       // Diğer route'lar için named navigation (route'lar tanımlanmışsa)
//       try {
//         Navigator.pushNamed(context, routePath);
//       } catch (e) {
//         // Route bulunamazsa hata mesajı göster
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Sayfa bulunamadı: $routePath'),
//             backgroundColor: Colors.orange,
//           ),
//         );
//       }
//     }
//   }

//   /// Menünün en altındaki alanı (Çıkış yap, versiyon vb.) oluşturan metot.
//   Widget _buildDrawerFooter(BuildContext context, AuthViewModel authState) {
//     return Column(
//       children: [
//         const Divider(height: 1, thickness: 1),
//         if (authState.isLoggedIn)
//           _buildMenuItem(
//             context,
//             icon: Icons.logout,
//             text: 'Çıkış Yap',
//             color: Colors.red[700],
//             onTap: () {
//               Navigator.pop(context); // Menüyü kapat
//               // AppBar'daki çıkış diyalogunu burada da kullanabilirsiniz.
//               _showLogoutConfirmDialog(context);
//             },
//           ),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 16.0),
//           child: Text(
//             'Versiyon 1.0.0',
//             style: TextStyle(color: Colors.grey[500], fontSize: 12),
//           ),
//         ),
//       ],
//     );
//   }

//   /// Tek bir menü elemanı oluşturan yardımcı metot.
//   Widget _buildMenuItem(
//     BuildContext context, {
//     required IconData icon,
//     required String text,
//     required VoidCallback onTap,
//     Color? color,
//   }) {
//     final itemColor = color ?? Colors.grey[800];
//     return ListTile(
//       leading: Icon(icon, color: itemColor),
//       title: Text(
//         text,
//         style: TextStyle(
//             fontSize: 16, color: itemColor, fontWeight: FontWeight.w500),
//       ),
//       onTap: onTap,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//       hoverColor: const Color(0xFF03448D).withOpacity(0.05),
//     );
//   }
// }

// // AppBar'dan kopyalanan Çıkış Diyalogu Metodu
// // Bu metodu ayrı bir "yardımcı" dosyasına taşıyarak iki yerde de kullanabilirsiniz.
// void _showLogoutConfirmDialog(BuildContext context) {
//   const Color dangerColor = Color(0xFFE53E3E);
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Row(
//           children: [
//             Icon(Icons.logout_rounded, color: dangerColor),
//             const SizedBox(width: 10),
//             Text('Çıkış Yap', style: TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//         content: const Text('Çıkış yapmak istediğinize emin misiniz?'),
//         actions: <Widget>[
//           TextButton(
//             child: Text('İptal', style: TextStyle(color: Colors.grey[700])),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//           FilledButton(
//             style: FilledButton.styleFrom(backgroundColor: dangerColor),
//             child: const Text('Evet, Çıkış Yap'),
//             onPressed: () async {
//               Navigator.of(context).pop();
//               await context.read<AuthViewModel>().logout();
//               if (context.mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: const Text('Başarıyla çıkış yapıldı.'),
//                     backgroundColor: Colors.green,
//                   ),
//                 );
//               }
//             },
//           ),
//         ],
//       );
//     },
//   );
// }