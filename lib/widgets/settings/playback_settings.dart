import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaybackSettingsPauseDuration extends StatefulWidget {
  const PlaybackSettingsPauseDuration({super.key});

  @override
  State<PlaybackSettingsPauseDuration> createState() =>
      _PlaybackSettingsPauseDurationState();
}

class _PlaybackSettingsPauseDurationState
    extends State<PlaybackSettingsPauseDuration> {
  int _playbackLineBreakPause = 1;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _playbackLineBreakPause = (prefs.getInt('linePause') ?? 1);
      _controller.text = _playbackLineBreakPause.toString();
    });
  }

  _saveSettings(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('linePause', value);
  }

  void _updatePauseDuration(String value) {
    final int? newValue = int.tryParse(value);
    if (newValue != null) {
      setState(() {
        _playbackLineBreakPause = newValue;
        _saveSettings(newValue);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Text(
          'Pause Duration (s)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            backgroundColor: Color.fromARGB(0, 0, 0, 0),
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 80,
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
            ),
            onChanged: _updatePauseDuration,
          ),
        ),
        const SizedBox(width: 8),
        const Text(" seconds"),
      ],
    );
  }
}

class PlaybackSettingsPitch extends StatefulWidget {
  const PlaybackSettingsPitch({super.key});

  @override
  State<PlaybackSettingsPitch> createState() => _PlaybackSettingsPitchState();
}

class _PlaybackSettingsPitchState extends State<PlaybackSettingsPitch> {
  double _playbackVoice = 1.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _playbackVoice = (prefs.getDouble('playbackPitch') ?? 1.0);
    });
  }

  Future<void> _saveSettings(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('playbackPitch', value);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Text(
          'Voice Pitch',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            backgroundColor: Color.fromARGB(0, 0, 0, 0),
          ),
        ),
        const Spacer(),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.lightBlueAccent, // Active track color
              inactiveTrackColor: Colors.blueGrey[100], // Inactive track color
              thumbColor:
                  Colors.blue, // Color of the thumb (the draggable part)
              overlayColor:
                  Colors.blue.withOpacity(0.2), // Overlay color when dragging
              valueIndicatorColor: Colors.blue, // Color of the value indicator
              trackHeight: 4.0, // Thickness of the track
            ),
            child: Slider(
              value: _playbackVoice,
              min: 0.5,
              max: 2.0,
              divisions: 15,
              label: _playbackVoice.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  _playbackVoice = value;
                });
                _saveSettings(value);
              },
            ),
          ),
        ),
        Text(
          _playbackVoice.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
