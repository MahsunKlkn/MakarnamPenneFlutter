import 'package:flutter/material.dart';

import '../../../../core/constants/color.dart';

class InfoCardGrid extends StatelessWidget {
  const InfoCardGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildInfoCard(Icons.list_alt_outlined, 'Siparişlerim'),
        const SizedBox(width: 12),
        _buildInfoCard(Icons.favorite_border, 'Favoriler'),
        const SizedBox(width: 12),
        _buildInfoCard(Icons.location_on_outlined, 'Adreslerim'),
      ],
    );
  }

  // Bu yardımcı metod artık sadece bu widget'a özel
  Widget _buildInfoCard(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: kBorderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: kDarkText, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: kDarkText, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}