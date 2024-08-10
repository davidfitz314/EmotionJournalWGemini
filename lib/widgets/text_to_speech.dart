import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MeditationGuidePage extends StatefulWidget {
  const MeditationGuidePage({super.key});

  @override
  State<MeditationGuidePage> createState() => _MeditationGuidePageState();
}

class _MeditationGuidePageState extends State<MeditationGuidePage> {
  final FlutterTts _flutterTts = FlutterTts();
  final String _meditationSteps = '''
  Step 1: Find a quiet and comfortable place to sit.
  Step 2: Close your eyes and take a few deep breaths.
  Step 3: Focus your attention on your breath.
  Step 4: If your mind wanders, gently bring your focus back to your breath.
  Step 5: Continue this practice for 5 to 10 minutes.
  Step 6: Slowly open your eyes and take a moment before resuming your day.
  ''';

  @override
  void initState() {
    super.initState();
    _flutterTts.setSpeechRate(0.4); // Adjust speech rate for calmness
    _flutterTts.setPitch(1.0); // Adjust pitch if needed
  }

  void _speak() async {
    if (_meditationSteps.isNotEmpty) {
      await _flutterTts.speak(_meditationSteps);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation Guide'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text(
              'Follow these meditation steps:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(_meditationSteps),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _speak,
              child: const Text('Read Instructions'),
            ),
          ],
        ),
      ),
    );
  }
}
