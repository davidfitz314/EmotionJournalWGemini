import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:myapp/db/database_service.dart';
import 'package:myapp/gemini/gemini_mindful.dart';
import 'package:myapp/main.dart';
import 'package:myapp/widgets/background_gradient.dart';

class MeditationApp extends ConsumerStatefulWidget {
  @override
  _MeditationAppState createState() => _MeditationAppState();
}

class _MeditationAppState extends ConsumerState<MeditationApp> {
  @override
  void initState() {
    super.initState();
    _fetchMeditationContent();
  }

  void _fetchMeditationContent() async {
    final geminiService = ref.read(mindfulServiceProvider);
    await geminiService.getMindfullness(
      "meditation",
      "stress, anxiety",
      "I felt overwhelmed today and need to relax.",
    );
  }

  @override
  Widget build(BuildContext context) {
    final mindfulResult = ref.watch(mindfulResultNotifier);

    return MaterialApp(
      home: mindfulResult != null
          ? MeditationGuidePage(meditationSteps: mindfulResult.content)
          : LoadingScreen(),
    );
  }
}

class MeditationGuidePage extends StatefulWidget {
  final List<String> meditationSteps;

  const MeditationGuidePage({super.key, required this.meditationSteps});

  @override
  State<MeditationGuidePage> createState() => _MeditationGuidePageState();
}

class _MeditationGuidePageState extends State<MeditationGuidePage> {
  final FlutterTts _flutterTts = FlutterTts();
  int _currentIndex = 0;
  double _speechRate = 0.5; // Default speech rate for better fluency
  double _pitch = 1.0; // Default pitch for natural tone

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
      _speechRate = (_speechRate + 0.1).clamp(0.1, 1.0); // Limit the max rate
      _flutterTts.setSpeechRate(_speechRate);
    });
  }

  void _decreaseSpeechRate() {
    setState(() {
      _speechRate = (_speechRate - 0.1).clamp(0.1, 1.0); // Limit the min rate
      _flutterTts.setSpeechRate(_speechRate);
    });
  }

  Future<void> _saveFavoriteMeditation() async {
    final titleController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Title'),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Meditation Title'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(titleController.text);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      final databaseService = DatabaseMeditationService();
      await databaseService.saveFavoriteMeditation(
        result,
        widget.meditationSteps,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Meditation saved as favorite!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation Guide'),
        backgroundColor: const Color(0xFFE0F7FA),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: _saveFavoriteMeditation,
            tooltip: 'Save as Favorite',
          ),
        ],
      ),
      body: Stack(
        children: [
          const GradientBg(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                const Text(
                  'Follow these meditation steps:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
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
                                  overflow:
                                      TextOverflow.visible, // Handle overflow
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
                Text(
                    'Current Speech Rate: $_speechRate'), // Display current rate
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      const GradientBg(),
      Center(child: CircularProgressIndicator()),
    ]));
  }
}