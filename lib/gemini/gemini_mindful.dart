import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

// Define your API key here
const apiKey = 'PLACE_API_KEY_HERE';

final mindfulResultNotifier =
    StateProvider<MindfulResultPayload?>((ref) => null);

final mindfulServiceProvider = Provider<GeminiMindfulService>((ref) {
  return GeminiMindfulService(ref);
});

class GeminiMindfulService {
  final Ref ref;
  const GeminiMindfulService(this.ref);

  Future<void> getMindfullness(
      String focus, String emotions, String journalContent) async {
    try {
      var model = GenerativeModel(
          model: 'gemini-1.5-pro',
          apiKey: apiKey, // <- ADD YOUR API KEY HERE
          generationConfig: GenerationConfig(
              responseMimeType: 'application/json',
              responseSchema: Schema.object(properties: {
                "mindfulReply": Schema.string(),
              })));

      final content = Content.text('''
        You are a mental health counselor with a focus in $focus.
        Your client has had an emotional day and wants an $focus exercise to help.
        Your client was feeling `$emotions` and wrote a journal entry `$journalContent` about it. 
        Please create an exercise or health practice using your expertise in $focus , that can help with your 
        clients current emotions and journal entry.

        Rules and Guidelines:
        * All replies must be appropriate for all ages.
        * Never send empty replies, if failed to find a proper exercise or error occurs, respond with "please try again!".
        * Your reply should use speech patterns not writing patterns.
        * Your response will be converted to a text to speech service, so please ensure practices like meditation have pauses for breathing.
        * reply in the form of a JSON payload response containing the following properties and value is a string array of the practices by line:
        {
          "mindfulReply": ["your response here."]
        }
        ''');

      var response = await model.generateContent([content]);
      var jsonPayload = json.decode(response.text!);
      ref.read(mindfulResultNotifier.notifier).state = MindfulResultPayload(
        content: jsonPayload['mindfulReply'],
      );
    } on Exception {
      rethrow;
    }
  }

  void clear() {
    ref.read(mindfulResultNotifier.notifier).state = null;
  }
}

class MindfulResultPayload {
  final String content;

  const MindfulResultPayload({
    required this.content,
  });
}


/*
"mindfulReply": [
    "Hello there.",
    "Let's take a deep breath together.",
    "Inhale slowly... and exhale.",
    "Wonderful.",
    "Today, we'll do a Kundalini exercise to balance your emotions and energy.",
    "Start by sitting comfortably with your spine straight.",
    "Rest your hands on your knees with palms facing up.",
    "Close your eyes gently and take a deep breath in through your nose.",
    "Feel your lungs filling with air.",
    "Hold your breath for a moment.",
    "And exhale slowly through your mouth.",
    "Let go of any tension.",
    "Great.",
    "Now, we'll begin a short meditation called the Kirtan Kriya.",
    "This is a powerful Kundalini exercise to release negative emotions and cultivate joy.",
    "Bring your focus to the top of your head.",
    "Mentally chant the sound 'Sa'.",
    "Feel the vibration at the crown of your head.",
    "Good.",
    "Now move your focus to your forehead.",
    "Chant the sound 'Ta'.",
    "Feel the vibration here.",
    "Next, bring your attention to your throat.",
    "Chant 'Na'.",
    "Feel the vibration at your throat.",
    "Finally, bring your attention to your heart.",
    "Chant 'Ma'.",
    "Let your heart fill with warmth.",
    "Repeat this sequence silently to yourself.",
    "Sa. Ta. Na. Ma.",
    "Continue for a few minutes.",
    "Inhale deeply now.",
    "And exhale.",
    "Feel the calming energy flow through you.",
    "Whenever you're ready, open your eyes gently.",
    "You've done wonderfully today.",
    "Remember, emotions are like waves.",
    "They come and go.",
    "But your inner peace is always there.",
    "Thank you for practicing with me."
  ]
*/