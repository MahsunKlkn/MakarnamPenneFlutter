// ignore_for_file: avoid_print
enum UserRole {
  candidate(1, 'Aday'),
  company(2, 'Şirket'),
  employer(3, 'İşveren');

  const UserRole(this.id, this.displayName);

  final int id;
  final String displayName;

  static UserRole fromId(int id) {
    switch (id) {
      case 1:
        return UserRole.candidate;
      case 2:
        return UserRole.company;
      case 3:
        return UserRole.employer;
      default:
        return UserRole.candidate;
    }
  }
}

class MenuItem {
  final int id;
  final String name;
  final String icon;
  final String routePath;
  final bool active;
  final List<MenuItem>? subMenu;
  final List<UserRole> allowedRoles;

  const MenuItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.routePath,
    this.active = false,
    this.subMenu,
    required this.allowedRoles,
  });

  bool isVisibleForRole(UserRole role) => allowedRoles.contains(role);

  List<MenuItem>? getFilteredSubMenu(UserRole role) {
    if (subMenu == null) return null;
    final filteredSubMenu = subMenu!
        .where((item) => item.isVisibleForRole(role))
        .toList();
    return filteredSubMenu.isEmpty ? null : filteredSubMenu;
  }
}

class RoleMenuManager {
  static const List<MenuItem> _allMenuItems = [
    // ==== ADAY ====
    MenuItem(
      id: 100,
      name: 'Profilim',
      icon: 'la-file-invoice',
      routePath: '/candidates-dashboard/my-resume',
      active: true,
      allowedRoles: [UserRole.candidate],
    ),
    MenuItem(
      id: 101,
      name: 'Başvurularım',
      icon: 'la-briefcase',
      routePath: '/candidates-dashboard/applied-jobs',
      allowedRoles: [UserRole.candidate],
    ),
    MenuItem(
      id: 102,
      name: 'Kayıtlı İlanlar',
      icon: 'la-bookmark-o',
      routePath: '/candidates-dashboard/short-listed-jobs',
      allowedRoles: [UserRole.candidate],
    ),
    MenuItem(
      id: 103,
      name: 'Duyurular',
      icon: 'la-bullhorn',
      // ✅ company-dashboard değil candidates-dashboard olacak
      routePath: '/candidates-dashboard/all-announcements',
      allowedRoles: [UserRole.candidate],
    ),
    MenuItem(
      id: 104,
      name: 'Şifre Değiştir',
      icon: 'la-lock',
      routePath: '/candidates-dashboard/change-password',
      allowedRoles: [UserRole.candidate],
    ),

    // ==== EMPLOYER ====
    MenuItem(
      id: 200,
      name: 'Dashboard',
      icon: 'la-home',
      routePath: '/employers-dashboard/dashboard',
      active: true,
      allowedRoles: [UserRole.employer],
    ),
    MenuItem(
      id: 201,
      name: 'Yeni İlan Ekle',
      icon: 'la-paper-plane',
      routePath: '/employers-dashboard/post-jobs',
      allowedRoles: [UserRole.employer],
    ),
    MenuItem(
      id: 202,
      name: 'İlan Yönetimi',
      icon: 'la-briefcase',
      routePath: '/employers-dashboard/manage-jobs',
      allowedRoles: [UserRole.employer],
    ),

    // Başvurular
    MenuItem(
      id: 300,
      name: 'Başvurular',
      icon: 'la-address-book',
      routePath: '#',
      allowedRoles: [UserRole.employer],
      subMenu: [
        MenuItem(
          id: 301,
          name: 'Tüm Başvurular',
          icon: 'la-file-invoice',
          routePath: '/employers-dashboard/all-applicants',
          allowedRoles: [UserRole.employer],
        ),
        MenuItem(
          id: 302,
          name: 'Staj Başvuruları',
          icon: 'la-file-invoice',
          routePath: '/employers-dashboard/all-applicants-intern',
          allowedRoles: [UserRole.employer],
        ),
        MenuItem(
          id: 303,
          name: 'Genel Başvurular',
          icon: 'la-file-invoice',
          routePath: '/employers-dashboard/general-application-admin',
          allowedRoles: [UserRole.employer],
        ),
        MenuItem(
          id: 304,
          name: 'Genel Başvuru CV Görüntüleme',
          icon: 'la-file-invoice',
          routePath: '/employers-dashboard/general-application-admin-cv',
          allowedRoles: [UserRole.employer],
        ),
      ],
    ),

    // Duyuru Yönetimi
    MenuItem(
      id: 310,
      name: 'Duyuru Yönetimi',
      icon: 'la-bullhorn',
      routePath: '#',
      allowedRoles: [UserRole.employer],
      subMenu: [
        MenuItem(
          id: 311,
          name: 'Duyuru Ekle',
          icon: 'la-plus',
          routePath: '/employers-dashboard/announcements',
          allowedRoles: [UserRole.employer],
        ),
        MenuItem(
          id: 312,
          name: 'Tüm Duyurular',
          icon: 'la-list',
          routePath: '/employers-dashboard/all-announcements',
          allowedRoles: [UserRole.employer],
        ),
        MenuItem(
          id: 313,
          name: 'Duyuru Güncelle',
          icon: 'la-edit',
          routePath: '/employers-dashboard/update-announcements',
          allowedRoles: [UserRole.employer],
        ),
      ],
    ),

    // Tanımlar
    MenuItem(
      id: 320,
      name: 'Tanımlar',
      icon: 'la-folder-open',
      routePath: '#',
      allowedRoles: [UserRole.employer],
      subMenu: [
        MenuItem(
          id: 321,
          name: 'Departman & Pozisyon',
          icon: 'la-building',
          routePath: '/employers-dashboard/post-sector',
          allowedRoles: [UserRole.employer],
        ),
        MenuItem(
          id: 322,
          name: 'Yabancı Dil',
          icon: 'la-language',
          routePath: '/employers-dashboard/post-foreignLanguage',
          allowedRoles: [UserRole.employer],
        ),
        MenuItem(
          id: 323,
          name: 'Ehliyet Tanımları',
          icon: 'la-car',
          routePath: '/employers-dashboard/post-drivingLicense',
          allowedRoles: [UserRole.employer],
        ),
      ],
    ),

    // Sponsor Yönetimi
    MenuItem(
      id: 330,
      name: 'Sponsor Yönetimi',
      icon: 'la-handshake-o',
      routePath: '#',
      allowedRoles: [UserRole.employer],
      subMenu: [
        MenuItem(
          id: 331,
          name: 'Sponsor Ekle',
          icon: 'la-plus',
          routePath: '/employers-dashboard/sponsor',
          allowedRoles: [UserRole.employer],
        ),
        MenuItem(
          id: 332,
          name: 'Tüm Sponsorlar',
          icon: 'la-list',
          routePath: '/employers-dashboard/all-sponsors',
          allowedRoles: [UserRole.employer],
        ),
        MenuItem(
          id: 333,
          name: 'Sponsor Türleri',
          icon: 'la-list',
          routePath: '/employers-dashboard/all-sponsorTypes',
          allowedRoles: [UserRole.employer],
        ),
      ],
    ),

    // Proje Yönetimi
    MenuItem(
      id: 340,
      name: 'Proje Yönetimi',
      icon: 'la-folder-open',
      routePath: '#',
      allowedRoles: [UserRole.employer],
      subMenu: [
        MenuItem(
          id: 341,
          name: 'Proje Ekle',
          icon: 'la-plus',
          routePath: '/employers-dashboard/project',
          allowedRoles: [UserRole.employer],
        ),
        MenuItem(
          id: 342,
          name: 'Tüm Projeler',
          icon: 'la-list',
          routePath: '/employers-dashboard/all-projects',
          allowedRoles: [UserRole.employer],
        ),
      ],
    ),

    // Haber Yönetimi
    MenuItem(
      id: 350,
      name: 'Haber Yönetimi',
      icon: 'la-newspaper-o',
      routePath: '#',
      allowedRoles: [UserRole.employer],
      subMenu: [
        MenuItem(
          id: 351,
          name: 'Haber Ekle',
          icon: 'la-plus',
          routePath: '/employers-dashboard/post-news',
          allowedRoles: [UserRole.employer],
        ),
        MenuItem(
          id: 352,
          name: 'Tüm Haberler',
          icon: 'la-list',
          routePath: '/employers-dashboard/post-newslist',
          allowedRoles: [UserRole.employer],
        ),
      ],
    ),

    // Felsefe (Misyon & Vizyon)
    MenuItem(
      id: 360,
      name: 'Misyon & Vizyon',
      icon: 'la-lightbulb-o',
      routePath: '#',
      allowedRoles: [UserRole.employer],
      subMenu: [
        MenuItem(
          id: 361,
          name: 'Tüm Bilgi Kartları',
          icon: 'la-question-circle',
          routePath: '/employers-dashboard/all-infocards',
          allowedRoles: [UserRole.employer],
        ),
        MenuItem(
          id: 362,
          name: 'Bilgi Kartı Ekle',
          icon: 'la-certificate',
          routePath: '/employers-dashboard/infocard',
          allowedRoles: [UserRole.employer],
        ),
      ],
    ),

    // Ayarlar
    MenuItem(
      id: 370,
      name: 'Ayarlar',
      icon: 'la-cog',
      routePath: '#',
      allowedRoles: [UserRole.employer],
      subMenu: [
        MenuItem(
          id: 371,
          name: 'Ana Sayfa Görünümü',
          icon: 'la-home',
          routePath: '/employers-dashboard/settings-management/homepage-view',
          allowedRoles: [UserRole.employer],
        ),
        MenuItem(
          id: 372,
          name: 'Genel Başvuru Ayarları',
          icon: 'la-list',
          routePath:
              '/employers-dashboard/settings-management/general-application-settings',
          allowedRoles: [UserRole.employer],
        ),
        MenuItem(
          id: 373,
          name: 'İlan Oluşturma Ayarları',
          icon: 'la-list',
          routePath:
              '/employers-dashboard/settings-management/job-posting-creation-settings',
          allowedRoles: [UserRole.employer],
        ),
        MenuItem(
          id: 374,
          name: 'İlan Başvuru Ayarları',
          icon: 'la-list',
          routePath:
              '/employers-dashboard/settings-management/job-posting-application-settings',
          allowedRoles: [UserRole.employer],
        ),
        MenuItem(
          id: 375,
          name: 'Özelleştirme Ayarları',
          icon: 'la-list',
          routePath:
              '/employers-dashboard/settings-management/customization-settings',
          allowedRoles: [UserRole.employer],
        ),
      ],
    ),

    // Diğer menüler
    MenuItem(
      id: 380,
      name: 'Kısa Liste Özgeçmişler',
      icon: 'la-bookmark-o',
      routePath: '/employers-dashboard/shortlisted-resumes',
      allowedRoles: [UserRole.employer],
    ),
    MenuItem(
      id: 381,
      name: 'Kısa Liste Adaylar',
      icon: 'la-bookmark-o',
      routePath: '/employers-dashboard/shortlisted-candidates',
      allowedRoles: [UserRole.employer],
    ),
    MenuItem(
      id: 382,
      name: 'Onay Yönetimi',
      icon: 'la-check',
      routePath: '/employers-dashboard/approval-management',
      allowedRoles: [UserRole.employer],
    ),
    MenuItem(
      id: 383,
      name: 'İlan Onayları',
      icon: 'la-clipboard-check',
      routePath: '/employers-dashboard/posting-approval',
      allowedRoles: [UserRole.employer],
    ),
    MenuItem(
      id: 384,
      name: 'Şifre Değiştir',
      icon: 'la-lock',
      routePath: '/employers-dashboard/change-password',
      allowedRoles: [UserRole.employer],
    ),
    // ==== COMPANY ====
    MenuItem(
      id: 400,
      name: 'Şirket Dashboard',
      icon: 'la-home',
      routePath: '/company-dashboard/dashboard',
      active: true,
      allowedRoles: [UserRole.company],
    ),

    MenuItem(
      id: 401,
      name: 'Şirket Profili',
      icon: 'la-building',
      routePath: '/company-dashboard/company-profile',
      allowedRoles: [UserRole.company],
    ),

    MenuItem(
      id: 402,
      name: 'Yeni İlan Ekle',
      icon: 'la-paper-plane',
      routePath: '/company-dashboard/post-jobs',
      allowedRoles: [UserRole.company],
    ),

    MenuItem(
      id: 403,
      name: 'Başvurular',
      icon: 'la-address-book',
      routePath: '#',
      allowedRoles: [UserRole.company],
      subMenu: [
        MenuItem(
          id: 404,
          name: 'Tüm Başvurular',
          icon: 'la-file-invoice',
          routePath: '/company-dashboard/all-applicants',
          allowedRoles: [UserRole.company],
        ),
        MenuItem(
          id: 405,
          name: 'Staj Başvuruları',
          icon: 'la-file-invoice',
          routePath: '/company-dashboard/all-applicants-intern',
          allowedRoles: [UserRole.company],
        ),
        MenuItem(
          id: 406,
          name: 'Genel Başvurular',
          icon: 'la-file-invoice',
          routePath: '/company-dashboard/general-application-company',
          allowedRoles: [UserRole.company],
        ),
        MenuItem(
          id: 407,
          name: 'Genel Başvuru CV Görüntüleme',
          icon: 'la-file-invoice',
          routePath: '/company-dashboard/general-application-company-cv',
          allowedRoles: [UserRole.company],
        ),
      ],
    ),

    MenuItem(
      id: 408,
      name: 'İşveren Yönetimi',
      icon: 'la-users',
      routePath: '/company-dashboard/manage-employers',
      allowedRoles: [UserRole.company],
    ),

    MenuItem(
      id: 409,
      name: 'Şifre Değiştir',
      icon: 'la-lock',
      routePath: '/company-dashboard/change-password',
      allowedRoles: [UserRole.company],
    ),
  ];

  static List<MenuItem> getMenuItemsForRole(UserRole role) {
    return _allMenuItems
        .where((item) => item.isVisibleForRole(role))
        .map((item) {
          final filteredSubMenu = item.getFilteredSubMenu(role);
          if (item.subMenu != null && filteredSubMenu == null) return null;
          return MenuItem(
            id: item.id,
            name: item.name,
            icon: item.icon,
            routePath: item.routePath,
            active: item.active,
            allowedRoles: item.allowedRoles,
            subMenu: filteredSubMenu,
          );
        })
        .whereType<MenuItem>()
        .toList();
  }

  static List<MenuItem> getMenuItemsFromTokenRole(int roleId) {
    final role = UserRole.fromId(roleId);
    return getMenuItemsForRole(role);
  }

  static String getHomeRouteForRole(UserRole role) {
    switch (role) {
      case UserRole.candidate:
        return '/home';
      case UserRole.employer:
        return '/employers-dashboard/dashboard';
      case UserRole.company:
        return '/company-dashboard/dashboard';
    }
  }

  static String getHomeRouteFromTokenRole(int roleId) {
    final role = UserRole.fromId(roleId);
    return getHomeRouteForRole(role);
  }

  static bool hasAccessToRoute(String routePath, UserRole role) {
    return _allMenuItems.any(
      (item) => item.routePath == routePath && item.isVisibleForRole(role),
    );
  }

  static bool hasAccessToRouteFromTokenRole(String routePath, int roleId) {
    final role = UserRole.fromId(roleId);
    return hasAccessToRoute(routePath, role);
  }

  static void printMenuStructure(UserRole role) {
    final menuItems = getMenuItemsForRole(role);
    print('=== ${role.displayName} Menü Yapısı ===');
    for (final item in menuItems) {
      print('${item.id}: ${item.name} (${item.routePath})');
      if (item.subMenu != null) {
        for (final subItem in item.subMenu!) {
          print('  └─ ${subItem.id}: ${subItem.name} (${subItem.routePath})');
        }
      }
    }
    print('================================');
  }
}
