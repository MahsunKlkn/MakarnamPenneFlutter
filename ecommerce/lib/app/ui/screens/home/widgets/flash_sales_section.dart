import 'package:flutter/material.dart';
import 'small_product_card.dart';

class FlashSalesSection extends StatelessWidget {
  const FlashSalesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildTimerBox("02"),
              _buildTimerSeparator(),
              _buildTimerBox("15"),
              _buildTimerSeparator(),
              _buildTimerBox("17"),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                SmallProductCard(
                  name: "Deksio",
                  price: "889.0",
                  oldPrice: "10.000",
                ),
                SmallProductCard(
                  name: "Ev Yapımı Baklava",
                  price: "",
                  oldPrice: "",
                ),
                SmallProductCard(
                  name: "Fırın Yapımı Sufle",
                  price: "",
                  oldPrice: "",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerBox(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        time,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTimerSeparator() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        ":",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}