import 'package:flutter/material.dart';

class JournalEntryDetails extends StatelessWidget {
  final Map<String, dynamic> entry;

  JournalEntryDetails({required this.entry});

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = entry['createdDate'] as DateTime;

    return Scaffold(
      appBar: AppBar(title: Text(entry['title'] ?? 'Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${entry['title'] ?? 'No Title'}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 16),
            Text(
              dateTime.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              entry['content'] ?? 'No Content',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
