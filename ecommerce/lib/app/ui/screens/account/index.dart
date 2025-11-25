import 'package:flutter/material.dart';

import '../../../core/constants/color.dart';
import 'widgets/account_header.dart';
import 'widgets/info_card_grid.dart';
import 'widgets/wallet_card.dart';
import 'widgets/section_header.dart';
import 'widgets/clickable_tile.dart';

class MyAccount extends StatelessWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Hesabım'),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings_outlined, color: kDarkText),
          onPressed: () {
            // Ayarlar sayfasına git
          },
        ),
      ],
    );
  }

  /// Gövde artık küçük, yeniden kullanılabilir widget'lardan oluşuyor
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Başlık Bölümü
            const AccountHeader(),
            const SizedBox(height: 24),

            // 2. Bilgi Kartları
            const InfoCardGrid(),
            const SizedBox(height: 16),

            // 3. Cüzdan Kartı
            const WalletCard(),
            const SizedBox(height: 32),

            // 4. "Fırsatlar" Bölümü
            const SectionHeader('Fırsatlar'),
            /*
            const ClickableTile(
              icon: Icons.star_border,
              title: 'YeClub',
              iconColor: kPrimaryColor,
            ),
            */
            const ClickableTile(
              icon: Icons.local_offer_outlined,
              title: 'Kuponlarım',
            ),
            const SizedBox(height: 24),

            // 5. "Daha Fazla" Bölümü
            const SectionHeader('Daha Fazla'),
            const ClickableTile(
              icon: Icons.help_outline,
              title: 'Yardım Merkezi',
            ),
            const ClickableTile(
              icon: Icons.description_outlined,
              title: 'Kullanım Koşulları ve Veri Politikası',
            ),
            const SectionHeader('Genel Ayarlar'),
              const ClickableTile(
                icon: Icons.language,
                title: 'Dil Ayarları',
              ),
              const ClickableTile(
                icon: Icons.notifications_outlined,
                title: 'Bildirim Ayarları',
              ),

              const SizedBox(height: 32), // Diğer bölümlerden ayırmak için boşluk
            const SizedBox(height: 32), // Diğer bölümlerden ayırmak için boşluk
            
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                // 1. Kenarlık rengini ve kalınlığını belirler
                side: const BorderSide(color: kPrimaryColor, width: 1.5),
                
                // 2. Butonun tam genişlikte olmasını sağlar
                minimumSize: const Size(double.infinity, 50), // Genişlik: kapla, Yükseklik: 50
                
                // 3. (İsteğe bağlı) Kenarları yuvarlatmak için
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: () {
                // TODO: Çıkış yapma logiğini buraya ekleyin
                print('Çıkış yap tıklandı!');
              },
              child: const Text(
                'Çıkış Yap',
                style: TextStyle(
                  color: kPrimaryColor, // Metin rengi
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}