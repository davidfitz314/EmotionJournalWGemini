import 'package:flutter/material.dart';
import 'package:myapp/widgets/background_gradient.dart';
import 'package:myapp/widgets/emotion_selector.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Stack(children: [
          GradientBg(),
          Center(
            child: EmotionSelector(),
          ),
        ]),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 6.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  // Save action
                },
              ),
              IconButton(
                icon: Icon(Icons.chat),
                onPressed: () {
                  // Chat action
                },
              ),
              IconButton(
                icon: Icon(Icons.more_horiz),
                onPressed: () {
                  // Another action
                },
              ),
            ],
          ),
        ));
  }
}
