import 'package:flutter/material.dart';

import '../../../../core/constants/color.dart';

class ClickableTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? iconColor;

  const ClickableTile({
    Key? key,
    required this.icon,
    required this.title,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: iconColor ?? kDarkText),
      title: Text(
        title,
        style: const TextStyle(color: kDarkText, fontSize: 16),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: () {
        // İlgili sayfaya yönlendirme
      },
    );
  }
}