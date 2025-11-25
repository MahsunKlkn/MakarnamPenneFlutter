import 'package:flutter/material.dart';
import 'total_summary.dart';
import 'confirm_button.dart';

class StickyBottomBar extends StatelessWidget {
  const StickyBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5), // Üste gölge
          )
        ],
      ),
      child: const Column(
        children: [
          TotalSummary(),
          ConfirmButton(),
        ],
      ),
    );
  }
}