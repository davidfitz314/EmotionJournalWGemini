import 'package:flutter/material.dart';
import 'package:myapp/widgets/background_gradient.dart';
import 'package:myapp/widgets/emotion_selector.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(children: [
        GradientBg(),
        Center(
          child: EmotionSelector(),
        ),
      ]),
    );
  }
}
