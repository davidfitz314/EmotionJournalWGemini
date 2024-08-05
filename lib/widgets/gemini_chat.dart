import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:myapp/gemini/gemini_mindful.dart';
import 'package:myapp/widgets/background_gradient.dart';

// ChatResultPayload model to store the chat response
class ChatResultPayload {
  final String content;

  const ChatResultPayload({
    required this.content,
  });
}

// Notifier to hold chat results
final chatResultNotifier = StateProvider<ChatResultPayload?>((ref) => null);

// Provider for the chat service
final chatServiceProvider = Provider<GeminiChatService>((ref) {
  return GeminiChatService(ref);
});

class GeminiChatService {
  final Ref ref;

  const GeminiChatService(this.ref);

  // Method to get a chat reply from the generative AI model
  Future<void> getChatReply(
      String userMessage, List<ChatMessage> oldMessages) async {
    StringBuffer buffer = StringBuffer();
    int numberOfMessagesToInclude = 10;

// Determine the starting index based on the size of the list
    int startIndex = oldMessages.length > numberOfMessagesToInclude
        ? oldMessages.length - numberOfMessagesToInclude
        : 0;

// Iterate over the last `numberOfMessagesToInclude` messages
    for (var i = startIndex; i < oldMessages.length; i++) {
      var message = oldMessages[i];
      if (message.content.contains(userMessage)) continue;

      // Format the message details
      buffer.writeln(
          "{ isUser: ${message.isUserMessage}, content: ${message.content} }");
    }

// Convert the buffer to a string
    String pastMessages = buffer.toString();
    try {
      var model = GenerativeModel(
        model: 'gemini-1.5-pro',
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
          responseSchema: Schema.object(properties: {
            "mindfulReply": Schema.string(),
          }),
        ),
      );

      final content = Content.text('''
        You are a mental health counselor offering a listening ear to users who want to talk about their feelings. Respond empathetically and provide thoughtful feedback based on the user's message.
        Please reply only to the content string in "userMessage".
        Past message context will be partially provided after the key "oldMessages" in order to help maintain the conversaiont flow.
        all replies must be in the form of a JSON payload response containing the following properties:
        {
          "mindfulReply": your response here.
        }

        "userMessage": $userMessage 

        "oldMessages": $pastMessages
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

  // Method to clear the chat result
  void clear() {
    ref.read(chatResultNotifier.notifier).state = null;
  }
}

class GeminiChat extends ConsumerStatefulWidget {
  const GeminiChat({super.key});

  @override
  ConsumerState<GeminiChat> createState() => _GeminiChatState();
}

class _GeminiChatState extends ConsumerState<GeminiChat> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFFE0F7FA),
        foregroundColor: const Color(0xFF2F4F4F),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat, color: Color(0xFF2F4F4F)),
            SizedBox(width: 16),
            Text('Mindful Chat', style: TextStyle(color: Color(0xFF2F4F4F))),
          ],
        ),
      ),
      body: Stack(
        children: [
          const GradientBg(),
          Column(
            children: [
              Expanded(
                child: ChatMessages(messages: _messages),
              ),
              MindfulRequestControls(
                messageController: _messageController,
                onSend: _handleSend,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Method to handle sending messages
  void _handleSend(String message) async {
    if (message.isNotEmpty) {
      // Add user message
      setState(() {
        _messages.add(ChatMessage(content: message, isUserMessage: true));
      });

      // Clear the input field
      _messageController.clear();

      // Get chat reply
      await ref.read(chatServiceProvider).getChatReply(message, _messages);

      // Add chat response
      final chatReply = ref.read(chatResultNotifier)?.content;
      if (chatReply != null) {
        setState(() {
          _messages.add(ChatMessage(content: chatReply, isUserMessage: false));
        });
      }
    }
  }
}

class MindfulRequestControls extends StatelessWidget {
  final TextEditingController messageController;
  final Function(String) onSend;

  const MindfulRequestControls({
    super.key,
    required this.messageController,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            color: Colors.blue,
            onPressed: () {
              onSend(messageController.text);
            },
          ),
        ],
      ),
    );
  }
}

class ChatMessages extends StatelessWidget {
  final List<ChatMessage> messages;

  const ChatMessages({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return Align(
          alignment: message.isUserMessage
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: message.isUserMessage
                  ? Colors.lightBlueAccent
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message.content,
              style: TextStyle(
                color: message.isUserMessage ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}

class ChatMessage {
  final String content;
  final bool isUserMessage;

  ChatMessage({required this.content, required this.isUserMessage});
  Map<String, dynamic> toJson() => {
        'content': content,
        'isUserMessage': isUserMessage,
      };
}
