import 'package:flutter/material.dart';
import 'package:myapp/widgets/background_gradient.dart';

class MindfulnessEntries extends StatefulWidget {
  const MindfulnessEntries({super.key});

  @override
  State<MindfulnessEntries> createState() => _MindfulnessEntriesState();
}

class _MindfulnessEntriesState extends State<MindfulnessEntries> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Stack(children: [
      GradientBg(),
      Center(
        child: Text("Saved Mindful Entries..."),
      ),
    ]),
    floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Chat',
        backgroundColor: Color(0xFF87CEFA),
        child: Icon(Icons.message),
      ),);
  }
}
