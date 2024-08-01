import 'package:flutter/material.dart';

class EmotionSelector extends StatefulWidget {
  const EmotionSelector({super.key});

  @override
  _EmotionSelectorState createState() => _EmotionSelectorState();
}

class _EmotionSelectorState extends State<EmotionSelector> {
  List<String> emotions = [
    'Joy', 'Love', 'Surprise', // Positive emotions
    'Neutral', 'Trust', // Neutral emotions
    'Sadness', 'Fear', 'Anger', // Negative emotions
  ];

  Map<String, bool> selectedEmotions = {
    'Joy': false,
    'Love': false,
    'Surprise': false,
    'Neutral': false,
    'Trust': false,
    'Sadness': false,
    'Fear': false,
    'Anger': false,
  };
  bool get isAnySelected {
    return selectedEmotions.values.any((value) => value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        title: const Text('How are you feeling today?',
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF2F4F4F),
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildCategoryRow(
                ['Joy', 'Love', 'Surprise'], Colors.green), // Positive emotions
            SizedBox(height: 16),
            buildCategoryRow(
                ['Neutral', 'Trust'], Colors.blue), // Neutral emotions
            SizedBox(height: 16),
            buildCategoryRow(['Sadness', 'Fear', 'Anger'], Colors.red),
            Visibility(
                visible: isAnySelected,
                child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Hello World',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF2F4F4F),
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        )) // Negative emotions,
                    ))
          ],
        ),
      ),
    );
  }

  Widget buildCategoryRow(List<String> categoryEmotions, Color categoryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: categoryEmotions.map((emotion) {
        return ToggleButton(
          text: emotion,
          isSelected: selectedEmotions[emotion] ?? false,
          onPressed: () {
            setState(() {
              selectedEmotions[emotion] = !selectedEmotions[emotion]!;
            });
          },
          color: categoryColor,
        );
      }).toList(),
    );
  }
}

class ToggleButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;
  final Color color;

  const ToggleButton({
    required this.text,
    required this.isSelected,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.8)
              : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
