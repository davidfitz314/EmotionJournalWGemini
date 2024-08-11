import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:myapp/widgets/background_gradient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeditationDetailsPage extends StatefulWidget {
  final String title;
  final List<String> meditationSteps;

  const MeditationDetailsPage({
    super.key,
    required this.title,
    required this.meditationSteps,
  });

  @override
  _MeditationDetailsPageState createState() => _MeditationDetailsPageState();
}

class _MeditationDetailsPageState extends State<MeditationDetailsPage> {
  final FlutterTts _flutterTts = FlutterTts();
  int _currentIndex = 0;
  double _speechRate = 0.8; // Local speech rate, not from SharedPreferences
  double _pitch = 1.0; // Default pitch

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _flutterTts.setLanguage('en-GB');
    _flutterTts.setCompletionHandler(_onComplete);
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _pitch = prefs.getDouble('playbackPitch') ?? 1.0;
      // Note: Pause duration is not used directly in FlutterTts but can be used for custom delays.
    });
  }

  void _speak() async {
    await _flutterTts.setSpeechRate(_speechRate);
    await _flutterTts.setPitch(_pitch);
    if (widget.meditationSteps.isNotEmpty &&
        _currentIndex < widget.meditationSteps.length) {
      String textToSpeak = widget.meditationSteps[_currentIndex];
      await _flutterTts.speak(textToSpeak);
    }
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  void _onComplete() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int pauseDuration = prefs.getInt('linePause') ?? 1;
    await Future.delayed(Duration(
        seconds: pauseDuration)); // Use pause duration from SharedPreferences
    setState(() {
      if (_currentIndex < widget.meditationSteps.length - 1) {
        _currentIndex++;
        _speak();
      }
    });
  }

  void _stop() async {
    await _flutterTts.stop();
  }

  void _increaseSpeechRate() {
    setState(() {
      _speechRate = (_speechRate + 0.1).clamp(0.1, 1.0);
      _speechRate = double.parse(_speechRate.toStringAsFixed(1));
    });
    _speak();
  }

  void _decreaseSpeechRate() {
    setState(() {
      _speechRate = (_speechRate - 0.1).clamp(0.1, 1.0);
      _speechRate = double.parse(_speechRate.toStringAsFixed(1));
    });
    _speak();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFFE0F7FA),
      ),
      body: Stack(
        children: [
          const GradientBg(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children:
                          List.generate(widget.meditationSteps.length, (index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          color: index == _currentIndex
                              ? Colors.lightBlueAccent
                              : Colors.transparent,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.meditationSteps[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: index == _currentIndex
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _currentIndex = 0; // Start from the beginning
                        _speak();
                      },
                      child: const Icon(Icons.play_arrow), // Play icon
                    ),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: _stop,
                      child: const Icon(Icons.stop), // Stop icon
                    ),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: _decreaseSpeechRate,
                      child: const Icon(Icons.remove), // Slow Down icon
                    ),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: _increaseSpeechRate,
                      child: const Icon(Icons.add), // Speed Up icon
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Speech Rate: ${_speechRate.toStringAsFixed(1)}x'),
                    IconButton(
                      icon: Icon(Icons.info_outline),
                      tooltip: 'Adjusts the speed at which the text is spoken.',
                      onPressed: () {
                        // Optionally show a dialog or tooltip with more info
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
