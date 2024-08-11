import 'package:flutter/material.dart';
import 'package:myapp/db/database_service.dart';
import 'package:myapp/widgets/background_gradient.dart';

class JournalEntryDetails extends StatelessWidget {
  final Map<String, dynamic> entry;
  final DatabaseEntryService _databaseService = DatabaseEntryService();

  JournalEntryDetails({super.key, required this.entry});

  Future<void> _deleteEntry(BuildContext context, String entryId) async {
    await _databaseService.deleteEntry(entryId);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, String entryId) async {
    bool? result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this entry?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      _deleteEntry(context, entryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime dateTime = entry['createdDate'] as DateTime;

    return Scaffold(
      appBar: AppBar(
        title: Text(dateTime.toString().split(" ")[0]),
        backgroundColor: const Color(0xFFE0F7FA).withOpacity(.8),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () =>
                _showDeleteConfirmationDialog(context, entry['id']),
          ),
        ],
      ),
      body: Stack(
        children: [
          const GradientBg(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "My Mood: ${entry['title'].toString().split(' ').join(', ')}",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
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
      ),
    );
  }
}
