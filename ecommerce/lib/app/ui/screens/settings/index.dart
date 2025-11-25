import 'package:flutter/material.dart';
import 'widgets/profile_header.dart';
import 'widgets/settings_section.dart';
import 'widgets/tiles.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const Color _primaryBlue = Color(0xFF03448D);

  bool _notifications = true;
  bool _darkMode = false;
  String _language = 'Türkçe';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _primaryBlue,
        foregroundColor: Colors.white,
        title: const Text('Ayarlar'),
        centerTitle: false,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ProfileHeader(onEdit: _onEditProfile),
          const SizedBox(height: 16),

          SettingsSection(
            title: 'Genel',
            children: [
              TileSwitch(
                icon: Icons.notifications_outlined,
                iconBg: _primaryBlue.withOpacity(0.1),
                iconColor: _primaryBlue,
                title: 'Bildirimler',
                subtitle: 'Push bildirimlerini aç/kapat',
                value: _notifications,
                onChanged: (v) => setState(() => _notifications = v),
              ),
              TileSwitch(
                icon: Icons.dark_mode_outlined,
                iconBg: Colors.amber.withOpacity(0.12),
                iconColor: Colors.amber.shade800,
                title: 'Karanlık tema',
                subtitle: 'Koyu görünüm',
                value: _darkMode,
                onChanged: (v) {
                  setState(() => _darkMode = v);
                  _showSnack('Tema tercihi kaydedildi');
                },
              ),
            ],
          ),

          SettingsSection(
            title: 'Hesap',
            children: [
              TileNav(
                icon: Icons.person_outline,
                iconBg: _primaryBlue.withOpacity(0.1),
                iconColor: _primaryBlue,
                title: 'Profil',
                subtitle: 'Bilgilerini güncelle',
                onTap: _goProfile,
              ),
              TileNav(
                icon: Icons.lock_outline,
                iconBg: Colors.red.withOpacity(0.1),
                iconColor: Colors.red,
                title: 'Gizlilik ve güvenlik',
                subtitle: 'Şifre ve güvenlik ayarları',
                onTap: _goPrivacy,
              ),
            ],
          ),

          SettingsSection(
            title: 'Uygulama',
            children: [
              TileValue(
                icon: Icons.language_outlined,
                iconBg: Colors.green.withOpacity(0.1),
                iconColor: Colors.green,
                title: 'Dil',
                value: _language,
                onTap: _pickLanguage,
              ),
              TileNav(
                icon: Icons.info_outline,
                iconBg: Colors.indigo.withOpacity(0.1),
                iconColor: Colors.indigo,
                title: 'Hakkında',
                subtitle: 'Sürüm ve bilgiler',
                onTap: _showAbout,
              ),
            ],
          ),

          const SizedBox(height: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Çıkış Yap'),
            onPressed: _logout,
          ),

          const SizedBox(height: 16),
          Center(
            child: Text(
              'v1.0.0',
              style: textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
          ),
        ],
      ),
    );
  }

  void _onEditProfile() {
    _showSnack('Profil düzenleme yakında');
  }

  void _goProfile() {
    _showSnack('Profil sayfası');
  }

  void _goPrivacy() {
    _showSnack('Gizlilik ve güvenlik');
  }

  void _pickLanguage() async {
    final languages = ['Türkçe', 'English', 'Deutsch', 'Русский'];
    final selected = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Dil Seçin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              ...languages.map((e) => ListTile(
                    title: Text(e),
                    trailing: e == _language ? const Icon(Icons.check, color: Colors.green) : null,
                    onTap: () => Navigator.pop(ctx, e),
                  )),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      setState(() => _language = selected);
    }
  }

  void _showAbout() {
    showAboutDialog(
      context: context,
      applicationName: 'Kariyer Limak',
      applicationVersion: '1.0.0',
      applicationIcon: const FlutterLogo(),
      children: const [
        Text('Bu uygulama kariyer ilanları ve başvurular için geliştirilmiştir.'),
      ],
    );
  }

  void _logout() {
    _showSnack('Çıkış yapıldı');
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}

// Moved inner widgets to widgets/ folder
