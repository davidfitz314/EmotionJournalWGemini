import 'package:flutter/material.dart';

class JournalEntries extends StatelessWidget {
  const JournalEntries({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Journal Entries'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        tooltip: 'Chat',
        child: Icon(Icons.message),
      ),
    );
  }
}
