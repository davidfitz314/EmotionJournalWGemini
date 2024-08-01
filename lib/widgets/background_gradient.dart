import 'package:flutter/material.dart';

class GradientBg extends StatelessWidget {
  const GradientBg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color(0xFFE0F7FA),
        Color(0xFF87CEFA),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
    );
  }
}
