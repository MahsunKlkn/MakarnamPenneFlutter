import 'package:flutter/material.dart';

class BasketStepper extends StatelessWidget {
  const BasketStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              _buildStepCircle('1', isDone: true),
              Expanded(
                  child: Container(height: 2, color: Colors.orange[700])),
              _buildStepCircle('2', isActive: true),
              Expanded(child: Container(height: 2, color: Colors.grey[300])),
              _buildStepCircle('3', isActive: false),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Menü',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Text('Sepetim',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[700],
                      fontWeight: FontWeight.bold)),
              const Text('Ödeme',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(String number,
      {bool isActive = false, bool isDone = false}) {
    final color =
        isActive ? Colors.orange[700] : (isDone ? Colors.black : Colors.grey[300]);
    final textColor = (isActive || isDone) ? Colors.white : Colors.grey[700];

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}