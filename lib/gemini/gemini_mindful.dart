import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final mindfulResultNotifier =
    StateProvider<MindfulResultPayload?>((ref) => null);

class GeminiMindfulService {
  final Ref ref;
  const GeminiMindfulService(this.ref);

  Future<void> getMindfullness() async {
    try {
      var model = GenerativeModel(
          model: 'gemini-1.5-pro',
          apiKey: 'YOUR_API_KEY_HERE', // <- ADD YOUR API KEY HERE
          generationConfig: GenerationConfig(
              responseMimeType: 'application/json',
              responseSchema: Schema.object(properties: {
                "mindfulReply": Schema.string(),
              })));

      final content = Content.text('''
        Hello Gemini, I am testing api, please  
        reply in the form of a JSON payload response containing the following properties:
        {
          "mindfulReply": your response here.
        }
        ''');

      var response = await model.generateContent([content]);
      var jsonPayload = json.decode(response.text!);
      ref.read(mindfulResultNotifier.notifier).state = MindfulResultPayload(
        name: jsonPayload['mindfulReply'],
      );
    } on Exception {
      rethrow;
    }
  }

  void clear() {
    // TODO: if additional content needed
  }
}

class MindfulResultPayload {
  final String name;

  const MindfulResultPayload({
    required this.name,
  });
}
