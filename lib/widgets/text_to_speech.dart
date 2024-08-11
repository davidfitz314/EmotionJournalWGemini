import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:myapp/db/database_service.dart';
import 'package:myapp/gemini/gemini_mindful.dart';
import 'package:myapp/main.dart';
import 'package:myapp/widgets/background_gradient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeditationApp extends ConsumerStatefulWidget {
  final String meditationStyle;
  final List<String> emotions;
  final String journalContent;

  const MeditationApp({
    Key? key,
    required this.meditationStyle,
    required this.emotions,
    required this.journalContent,
  }) : super(key: key);

  @override
  _MeditationAppState createState() => _MeditationAppState();
}

class _MeditationAppState extends ConsumerState<MeditationApp> {
  int _pauseDuration = 2;
  double _voicePitch = 1.0;

  @override
  void initState() {
    super.initState();
    _fetchMeditationContent();
  }

  void _fetchMeditationContent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final geminiService = ref.read(mindfulServiceProvider);
    await geminiService.getMindfullness(
      widget.meditationStyle,
      widget.emotions.join(', '), // Pass emotions as a comma-separated string
      widget.journalContent, // Pass journal content
    );
    setState(() {
      _pauseDuration = prefs.getInt('linePause') ?? 1;
      _voicePitch = prefs.getDouble('playbackPitch') ?? 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mindfulResult = ref.watch(mindfulResultNotifier);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: mindfulResult != null
          ? MeditationGuidePage(
              meditationSteps: mindfulResult.content,
              voicePitch: _voicePitch,
              pauseDuration: _pauseDuration,
            )
          : LoadingScreen(),
    );
  }
}

class MeditationGuidePage extends StatefulWidget {
  final List<String> meditationSteps;
  final double voicePitch;
  final int pauseDuration;

  const MeditationGuidePage({
    super.key,
    required this.meditationSteps,
    required this.voicePitch,
    required this.pauseDuration,
  });

  @override
  State<MeditationGuidePage> createState() => _MeditationGuidePageState();
}

class _MeditationGuidePageState extends State<MeditationGuidePage> {
  final FlutterTts _flutterTts = FlutterTts();
  int _currentIndex = 0;
  double _speechRate = 0.8; // Default speech rate for better fluency

  @override
  void initState() {
    super.initState();
    _flutterTts.setSpeechRate(_speechRate);
    _flutterTts.setPitch(widget.voicePitch); // Use pitch from widget
    _flutterTts.setLanguage('en-GB');
    _flutterTts.setCompletionHandler(_onComplete);
  }

  void _speak() async {
    if (widget.meditationSteps.isNotEmpty &&
        _currentIndex < widget.meditationSteps.length) {
      String textToSpeak = widget.meditationSteps[_currentIndex];
      await _flutterTts.speak(textToSpeak);
    }
  }

  void _onComplete() async {
    setState(() {
      if (_currentIndex < widget.meditationSteps.length - 1) {
        _currentIndex++;
      }
    });
    await Future.delayed(Duration(
        seconds: widget.pauseDuration)); // Use pause duration from widget
    _speak();
  }

  void _stop() async {
    await _flutterTts.stop();
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  void _increaseSpeechRate() {
    setState(() {
      _speechRate = (_speechRate + 0.1).clamp(0.1, 1.0);
      _speechRate = double.parse(_speechRate.toStringAsFixed(1));
      _flutterTts.setSpeechRate(_speechRate);
    });
  }

  void _decreaseSpeechRate() {
    setState(() {
      _speechRate = (_speechRate - 0.1).clamp(0.1, 1.0);
      _speechRate = double.parse(_speechRate.toStringAsFixed(1));
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
              MaterialPageRoute(
                  builder: (context) => MyApp(
                        selectedIndex: 0,
                      )),
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
                ) // Display current rate
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
      body: Stack(
        children: [
          const GradientBg(),
          Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
