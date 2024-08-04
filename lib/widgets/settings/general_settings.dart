import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> list = <String>[
  'Daily',
  '2 Days',
  '3 Days',
  '4 Days',
  '5 Days',
  '6 Days',
  'Weekly',
  'Monthly'
];

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({super.key});

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  String _remindersDurationSelection = list.first;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _remindersDurationSelection =
          (prefs.getString('remindersDurationSelection') ?? list.first);
    });
  }

  _saveSettings(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('remindersDurationSelection', value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      const Text(
        'Reminders:',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          backgroundColor: Color.fromARGB(0, 0, 0, 0),
        ),
      ),
      const Spacer(),
      DropdownButton<String>(
        value: _remindersDurationSelection,
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
            _remindersDurationSelection = value!;
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

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool _showNotifications = false;
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _showNotifications = (prefs.getBool('showNotifications') ?? false);
    });
  }

  // ignore: unused_element
  _saveSettings(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('showNotifications', value);
  }

// Suggested code may be subject to a license. Learn more: ~LicenseLog:531234684.
  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      const Text(
        'Notifications:',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          backgroundColor: Color.fromARGB(0, 0, 0, 0),
        ),
      ),
      const Spacer(),
      Switch(
        value: _showNotifications,
        onChanged: (value) {
          setState(() {
            _showNotifications = value;
            _saveSettings(value);
          });
        },
      ),
    ]);
  }
}
