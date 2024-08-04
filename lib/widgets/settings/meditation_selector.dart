import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> list = <String>[
  'Mindfulness',
  'Yoga',
  'Kundalini',
  'Chinese Medicine',
  'Qi Gong',
  'Reiki',
  'Chakras',
  'Self-Hypnosis',
  'Affirmations',
  'Breathwork',
  'Meditation'
];

class MeditationSelector extends StatefulWidget {
  const MeditationSelector({super.key});

  @override
  State<MeditationSelector> createState() => _MeditationSelectorState();
}

class _MeditationSelectorState extends State<MeditationSelector> {
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
          (prefs.getString('meditationStyleSelection') ?? list.first);
    });
  }

  _saveSettings(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('meditationStyleSelection', value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const Text(
            'Focus',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              backgroundColor: Color.fromARGB(0, 0, 0, 0),
            ),
          ),
          Spacer(),
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
