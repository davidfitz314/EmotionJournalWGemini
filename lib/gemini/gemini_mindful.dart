import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

// Define your API key here
const apiKey = 'Insert_API_KEY_HERE';

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
                "mindfulReply": Schema.array(items: Schema.string()),
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
        * Your meditation should take approximately 5 minutes to complete when using a text to speech service.
        * Never put your entire content into only 1 string, it should always be broken up into multiple strings in the array.
        * Your response will be converted to a text to speech service, so please ensure practices like meditation have pauses for breathing.
        * reply in the form of a JSON payload response containing the following properties and value is a string array of the practices by line:
        {
          "mindfulReply": ["your response here."]
        }
        ''');

      var response = await model.generateContent([content]);
      var jsonPayload = json.decode(response.text!);
      ref.read(mindfulResultNotifier.notifier).state = MindfulResultPayload(
        content: List<String>.from(jsonPayload['mindfulReply']),
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
  final List<String> content;

  const MindfulResultPayload({
    required this.content,
  });
}
