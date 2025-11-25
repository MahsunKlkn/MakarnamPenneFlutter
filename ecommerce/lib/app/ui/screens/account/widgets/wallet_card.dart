import 'package:flutter/material.dart';

import '../../../../core/constants/color.dart';


class WalletCard extends StatelessWidget {
  const WalletCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
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
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet_outlined, color: kPrimaryColor),
          const SizedBox(width: 12),
          const Text(
            'Cüzdan',
            style: TextStyle(
              fontSize: 16,
              color: kDarkText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          const Text(
            '0,00 TL',
            style: TextStyle(
              fontSize: 16,
              color: kDarkText,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}