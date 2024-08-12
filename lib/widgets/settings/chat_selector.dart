import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> list = <String>[
  "Listening",
  "Empathy",
  "Communication",
  "Assessment",
  "Goal Setting",
  "Coping Strategies",
  "Behavioral Interventions",
  "Cognitive Restructuring",
  "Emotional Regulation",
  "Crisis Intervention",
  "Supportive Feedback",
  "Mindfulness and Relaxation",
  "Relationship Issues",
  "Self-Esteem Building",
  "Education"
];

class ChatFocusSelector extends StatefulWidget {
  const ChatFocusSelector({super.key});

  @override
  State<ChatFocusSelector> createState() => _ChatFocusSelectorState();
}

class _ChatFocusSelectorState extends State<ChatFocusSelector> {
  String _meditationStyleSelection = list.first;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _meditationStyleSelection =
          (prefs.getString('chatFocusSelection') ?? list.first);
    });
  }

  _saveSettings(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('chatFocusSelection', value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const Text(
            'Chat Expertise',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              backgroundColor: Color.fromARGB(0, 0, 0, 0),
            ),
          ),
          const Spacer(),
          DropdownButton<String>(
            value: _meditationStyleSelection,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            // style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              // color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                _meditationStyleSelection = value!;
                _saveSettings(value);
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )
        ]);
  }
}
