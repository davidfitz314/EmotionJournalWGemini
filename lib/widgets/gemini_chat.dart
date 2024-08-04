import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/gemini/gemini_mindful.dart';

class GeminiChat extends StatefulWidget {
  const GeminiChat({super.key});

  @override
  State<GeminiChat> createState() => _GeminiChatState();
}

class _GeminiChatState extends State<GeminiChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.collections, color: Colors.purple),
              SizedBox(width: 16),
              Text('Chat', style: TextStyle(color: Colors.purple))
            ],
          ),
        ),
        body: const Center(
            child: Column(
          children: [Text("Hello"), MindfulRequestControls(), ChatResponse()],
        )));
  }
}

class MindfulRequestControls extends ConsumerWidget {
  const MindfulRequestControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
              onPressed: () async {
                await ref.read(mindfulServiceProvider).getMindfullness();
              },
              icon: const Icon(Icons.image),
              label: const Text('Send')),
          const SizedBox(width: 24),
          ElevatedButton.icon(
              icon: const Icon(Icons.clear),
              onPressed: () async {
                ref.read(mindfulServiceProvider).clear();
              },
              label: const Text('Clear'))
        ],
      ),
    );
  }
}

class ChatResponse extends ConsumerWidget {
  const ChatResponse({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultPayload = ref.watch(mindfulResultNotifier);

    if (resultPayload == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Response',
                  style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
                ),
                Text(
                  resultPayload.content,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
