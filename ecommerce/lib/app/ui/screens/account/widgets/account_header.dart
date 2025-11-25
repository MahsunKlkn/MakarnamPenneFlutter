import 'package:flutter/material.dart';

import '../../../../core/constants/color.dart';


class AccountHeader extends StatelessWidget {
  const AccountHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mahsun',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: kDarkText,
          ),
        ),
        Text(
          'Hesabım',
          style: TextStyle(
            fontSize: 16,
            color: kLightText,
          ),
        ),
      ],
    );
  }
}