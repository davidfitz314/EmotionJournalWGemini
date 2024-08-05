import 'package:flutter/material.dart';
import 'package:myapp/widgets/background_gradient.dart';

class JournalEntryDetails extends StatelessWidget {
  final Map<String, dynamic> entry;

  const JournalEntryDetails({required this.entry});

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = entry['createdDate'] as DateTime;

    return Scaffold(
        appBar: AppBar(
          title:
              Text(entry['createdDate'].toString().split(" ")[0] ?? 'Details'),
          backgroundColor: Color(0xFFE0F7FA).withOpacity(.8),
        ),
        body: Stack(
          children: [
            GradientBg(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "My Mood: ${entry['title'].toString().split(' ').join(', ')}",
                    style: Theme.of(context).textTheme.headlineSmall,
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
          ],
        ));
  }
}
