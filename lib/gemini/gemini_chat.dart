import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final chatResultNotifier = StateProvider<ChatResultPayload?>((ref) => null);

final chatServiceProvider = Provider<GeminiChatService>((ref) {
  return GeminiChatService(ref);
});

class GeminiChatService {
  final Ref ref;
  const GeminiChatService(this.ref);

  Future<void> getChatReply() async {
    try {
      var model = GenerativeModel(
          model: 'gemini-1.5-pro',
          apiKey: '', // <- ADD YOUR API KEY HERE
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
      ref.read(chatResultNotifier.notifier).state = ChatResultPayload(
        content: jsonPayload['mindfulReply'],
      );
    } on Exception {
      rethrow;
    }
  }

  void clear() {
    ref.read(chatResultNotifier.notifier).state = null;
  }
}

class ChatResultPayload {
  final String content;

  const ChatResultPayload({
    required this.content,
  });
}
