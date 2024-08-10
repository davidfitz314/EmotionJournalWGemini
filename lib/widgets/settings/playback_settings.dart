import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Suggested code may be subject to a license. Learn more: ~LicenseLog:2071469947.
class PlaybackSettingsSpeed extends StatefulWidget {
  const PlaybackSettingsSpeed({super.key});

  @override
  State<PlaybackSettingsSpeed> createState() => _PlaybackSettingsSpeedState();
}

class _PlaybackSettingsSpeedState extends State<PlaybackSettingsSpeed> {
  double _playbackSpeed = 1.0;
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _playbackSpeed = (prefs.getDouble('playbackSpeed') ?? 1.0);
    });
  }

  // ignore: unused_element
  _saveSettings(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('playbackSpeed', value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      const Text(
        'Playback Speed',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          backgroundColor: Color.fromARGB(0, 0, 0, 0),
        ),
      ),
      const Spacer(),
      Text("Placeholder: $_playbackSpeed")
      // Switch(
      //   value: _playbackSpeed.toString(),
      //   onChanged: (value) {
      //     setState(() {
      //       _playbackSpeed = value;
      //       _saveSettings(value);
      //     });
      //   },
      // ),
    ]);
  }
}

class PlaybackSettingsVoice extends StatefulWidget {
  const PlaybackSettingsVoice({super.key});

  @override
  State<PlaybackSettingsVoice> createState() => _PlaybackSettingsVoiceState();
}

class _PlaybackSettingsVoiceState extends State<PlaybackSettingsVoice> {
  String _playbackVoice = "voice 1";
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _playbackVoice = (prefs.getString('playbackVoice') ?? 'voice 1');
    });
  }

  // ignore: unused_element
  _saveSettings(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('playbackVoice', value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      const Text(
        'Playback Voice',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          backgroundColor: Color.fromARGB(0, 0, 0, 0),
        ),
      ),
      const Spacer(),
      Text("Placeholder: $_playbackVoice")
      // Switch(
      //   value: _playbackSpeed.toString(),
      //   onChanged: (value) {
      //     setState(() {
      //       _playbackSpeed = value;
      //       _saveSettings(value);
      //     });
      //   },
      // ),
    ]);
  }
}
