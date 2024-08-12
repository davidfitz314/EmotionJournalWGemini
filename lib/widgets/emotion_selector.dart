import 'package:flutter/material.dart';
import 'package:myapp/db/database_service.dart';
import 'package:myapp/main.dart';
import 'package:myapp/widgets/gemini_chat.dart';
import 'package:myapp/widgets/text_to_speech.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmotionSelector extends StatefulWidget {
  const EmotionSelector({super.key});

  @override
  State<EmotionSelector> createState() => _EmotionSelectorState();
}

class _EmotionSelectorState extends State<EmotionSelector> {
  final DatabaseEntryService _databaseService = DatabaseEntryService();

  List<String> emotions = [
    'Joy', 'Love', 'Surprise', // Positive emotions
    'Neutral', 'Trust', // Neutral emotions
    'Sadness', 'Fear', 'Anger', // Negative emotions
  ];

  Map<String, bool> selectedEmotions = {
    'Joy': false,
    'Love': false,
    'Surprise': false,
    'Neutral': false,
    'Trust': false,
    'Sadness': false,
    'Fear': false,
    'Anger': false,
  };
  bool get isAnySelected {
    return selectedEmotions.values.any((value) => value) ||
        _controller.text.isNotEmpty;
  }

  final TextEditingController _controller = TextEditingController();
  String _mindfulPractice = "mindfulness"; // Default value

  @override
  void initState() {
    super.initState();
    _loadMindfulPractice();
  }

  void _loadMindfulPractice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _mindfulPractice =
          prefs.getString('meditationStyleSelection') ?? "mindfulness";
    });
  }

  void handleReset() {
    setState(() {
      selectedEmotions.forEach((key, value) {
        selectedEmotions[key] = false;
      });
    });
    _controller.text = "";
  }

  Future<void> createJournalEntry() async {
    String temppTitle = "";
    selectedEmotions.forEach((key, value) {
      if (value) {
        temppTitle += '$key ';
      }
    });
    DateTime createdDate = DateTime.now();
    await _databaseService.addEntry({
      'title': temppTitle,
      'createdDate': createdDate,
      'content': _controller.text,
    });
    _showConfirmationDialog(); // Call the dialog after saving the entry
  }

  void _showConfirmationDialog() async {
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
              'Would you like to do a $_mindfulPractice practice based on your Journal Entry?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MeditationApp(
                        meditationStyle: _mindfulPractice,
                        emotions: selectedEmotions.entries
                            .where((entry) => entry.value)
                            .map((entry) => entry.key)
                            .toList(),
                        journalContent: _controller.text),
                  ),
                );
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyApp(
                        selectedIndex:
                            1), // Update this if you have a specific JournalEntries widget
                  ),
                );
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        title: const Text('How are you feeling today?',
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF2F4F4F),
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            buildCategoryRow(
                ['Joy', 'Love', 'Surprise'], Colors.green), // Positive emotions
            const SizedBox(height: 16),
            buildCategoryRow(
                ['Neutral', 'Trust'], Colors.blue), // Neutral emotions
            const SizedBox(height: 16),
            buildCategoryRow(['Sadness', 'Fear', 'Anger'], Colors.red),
            Visibility(
                visible: isAnySelected,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Lets Journal it!',
                      hintText: 'What you feel matters the most...',
                      fillColor: Color.fromARGB(255, 235, 248, 255),
                      filled: true,
                    ),
                    maxLines: null, // Allows unlimited lines
                    minLines: 7,
                    keyboardType: TextInputType.multiline,
                  ),
                )),
            Visibility(
                visible: isAnySelected,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 24),
                    ElevatedButton.icon(
                        onPressed: () async {
                          await createJournalEntry();
                          _showConfirmationDialog();
                        },
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('Save')),
                    const SizedBox(width: 24),
                    ElevatedButton.icon(
                        icon: const Icon(Icons.clear),
                        onPressed: () async {
                          handleReset();
                        },
                        label: const Text('Clear'))
                  ],
                ))
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GeminiChat(),
            ),
          ),
        },
        tooltip: 'Chat',
        backgroundColor: const Color(0xFFE0F7FA),
        child: const Icon(Icons.message),
      ),
    );
  }

  Widget buildCategoryRow(List<String> categoryEmotions, Color categoryColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: categoryEmotions.map((emotion) {
        return ToggleButton(
          text: emotion,
          isSelected: selectedEmotions[emotion] ?? false,
          onPressed: () {
            setState(() {
              selectedEmotions[emotion] = !selectedEmotions[emotion]!;
            });
          },
          color: categoryColor,
        );
      }).toList(),
    );
  }
}

class ToggleButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;
  final Color color;

  const ToggleButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.8)
              : const Color.fromARGB(255, 75, 183, 251).withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
