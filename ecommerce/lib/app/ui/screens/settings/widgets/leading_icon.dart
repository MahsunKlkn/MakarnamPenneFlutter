import 'package:flutter/material.dart';

class LeadingIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  const LeadingIcon({super.key, required this.icon, required this.iconColor, required this.iconBg});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: iconBg,
      child: Icon(icon, color: iconColor),
    );
  }
}
