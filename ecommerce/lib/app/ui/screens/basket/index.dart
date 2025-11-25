import 'package:flutter/material.dart';

import '../home/widgets/section_title.dart';
import '../home/widgets/special_offers_section.dart';
import 'widgets/add_more_item_button.dart';
import 'widgets/basket_stepper.dart';
import 'widgets/card_item.dart';
import 'widgets/delivery_card.dart';

import 'widgets/sticky_button.dart'; // <-- Yeni toplu import dosyamız

class BasketScreen extends StatelessWidget {
  const BasketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sepetim',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Makarnam Penne", // Restoran adı
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BasketStepper(), 
                  const DeliveryCard(),
                  const CartItem(),
                  const AddMoreItemButton(),
                  Container(
                    height: 8,
                    color: Colors.grey[200],
                  ),
                  const SectionTitle(title: 'Sepetine bunları da ekleyebilirsin!'),
                  const SpecialOffersSection(),
                ],
              ),
            ),
          ),
          // 2. Sabit Alt Alan
          const StickyBottomBar(), // <-- Değişti
        ],
      ),
    );
  }
}