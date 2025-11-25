import 'package:flutter/material.dart';

class AddMoreItemButton extends StatelessWidget {
  const AddMoreItemButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 8),
      child: TextButton.icon(
        style: TextButton.styleFrom(
          foregroundColor: Colors.orange[700],
          minimumSize: const Size(double.infinity, 50), // Tam genişlik
        ),
        icon: const Icon(Icons.add),
        label: const Text('Daha Fazla Ürün Ekle',
            style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () {},
      ),
    );
  }
}