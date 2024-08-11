import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:myapp/widgets/background_gradient.dart';

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
  double _speechRate = 0.5;
  double _pitch = 1.0;

  @override
  void initState() {
    super.initState();
    _flutterTts.setSpeechRate(_speechRate);
    _flutterTts.setPitch(_pitch);
    _flutterTts.setCompletionHandler(_onComplete);
  }

  void _speak() async {
    if (widget.meditationSteps.isNotEmpty &&
        _currentIndex < widget.meditationSteps.length) {
      String textToSpeak = widget.meditationSteps[_currentIndex];
      String ssmlText = '''
      <speak>
        ${textToSpeak}
        <break time="2000ms"/>
      </speak>
    ''';
      await _flutterTts.speak(ssmlText);
    }
  }

  void _onComplete() {
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
      _flutterTts.setSpeechRate(_speechRate);
    });
  }

  void _decreaseSpeechRate() {
    setState(() {
      _speechRate = (_speechRate - 0.1).clamp(0.1, 1.0);
      _flutterTts.setSpeechRate(_speechRate);
    });
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
                      child: const Text('Play'),
                    ),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: _stop,
                      child: const Text('Stop'),
                    ),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: _decreaseSpeechRate,
                      child: const Text('Slow Down'),
                    ),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                      onPressed: _increaseSpeechRate,
                      child: const Text('Speed Up'),
                    ),
                  ],
                ),
                Text('Current Speech Rate: $_speechRate'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
