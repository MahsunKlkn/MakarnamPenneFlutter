import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../viewmodels/auth_view_model.dart';
import '../../basket/index.dart';
import '../../auth/widgets/login_dialog.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authState, child) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Makarnam Penne",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              Row(
                children: [
                  // Sepet ikonu
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BasketScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_basket_outlined, size: 28),
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 8),

                  // Kullanıcı durumuna göre dinamik buton/ikon
                  _buildUserActionButton(context, authState),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Kullanıcı durumuna göre giriş yap butonu veya profil ikonu gösterir
  Widget _buildUserActionButton(BuildContext context, AuthViewModel authState) {
    // Durum kontrol ediliyorsa loading göster
    if (authState.isCheckingStatus) {
      return const SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black54),
      );
    }

    // Kullanıcı giriş yapmışsa profil ikonu göster
    if (authState.isLoggedIn) {
      return PopupMenuButton<String>(
        icon: const Icon(Icons.person, size: 28, color: Colors.black54),
        tooltip: 'Profil Menüsü',
        offset: const Offset(0, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<String>(
            value: 'profile',
            child: Row(
              children: [
                const Icon(Icons.account_circle_outlined, size: 20),
                const SizedBox(width: 12),
                Text('Profilim', style: TextStyle(color: Colors.grey[800])),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'orders',
            child: Row(
              children: [
                const Icon(Icons.shopping_bag_outlined, size: 20),
                const SizedBox(width: 12),
                Text('Siparişlerim', style: TextStyle(color: Colors.grey[800])),
              ],
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<String>(
            value: 'logout',
            child: Row(
              children: [
                const Icon(Icons.logout, size: 20, color: Colors.red),
                const SizedBox(width: 12),
                Text('Çıkış Yap', style: TextStyle(color: Colors.red[700])),
              ],
            ),
          ),
        ],
        onSelected: (String value) {
          switch (value) {
            case 'profile':
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profil sayfası yakında eklenecek'),
                  backgroundColor: Colors.orange,
                ),
              );
              break;
            case 'orders':
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Siparişlerim sayfası yakında eklenecek'),
                  backgroundColor: Colors.orange,
                ),
              );
              break;
            case 'logout':
              _showLogoutConfirmDialog(context);
              break;
          }
        },
      );
    }

    // Kullanıcı giriş yapmamışsa giriş yap butonu göster
    return OutlinedButton(
      onPressed: () => _showLoginDialog(context),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF003366),
        side: BorderSide(color: Colors.grey[350]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),

        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: const Text(
        'Giriş Yap',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Login diyalogunu gösteren metot
  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const LoginDialog(),
    );
  }

  /// Çıkış onay diyalogunu gösteren metot
  void _showLogoutConfirmDialog(BuildContext context) {
    const Color dangerColor = Color(0xFFE53E3E);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: Colors.white,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Başlık ve ikon
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: dangerColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            color: dangerColor,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Çıkış Yap',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Açıklama metni
                    Text(
                      'Çıkış yapmak istediğinize emin misiniz?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Butonlar
                    Row(
                      children: [
                        // İptal butonu
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300),
                                foregroundColor: Colors.grey[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'İptal',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Çıkış yap butonu
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: FilledButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await context.read<AuthViewModel>().logout();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 8),
                                          Text('Başarıyla çıkış yapıldı'),
                                        ],
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                }
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: dangerColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Çıkış Yap',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Kapatma butonu
              Positioned(
                right: 8.0,
                top: 8.0,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(Icons.close, color: Colors.grey[400], size: 20),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
