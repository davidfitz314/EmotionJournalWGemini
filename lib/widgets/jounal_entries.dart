import 'package:flutter/material.dart';
import 'package:myapp/db/database_service.dart';
import 'package:myapp/widgets/background_gradient.dart';
import 'package:myapp/widgets/gemini_chat.dart';
import 'package:myapp/widgets/journal_entry_details.dart';
import 'dart:math' as math;

class JournalEntries extends StatefulWidget {
  const JournalEntries({super.key});
  @override
  State<JournalEntries> createState() => _JournalEntriesState();
}

class _JournalEntriesState extends State<JournalEntries> {
  final DatabaseEntryService _databaseService = DatabaseEntryService();
  List<Map<String, dynamic>> _entries = [];

  @override
  void initState() {
    super.initState();
    _fetchEntries();
  }

  Future<void> _fetchEntries() async {
    List<Map<String, dynamic>> entries = await _databaseService.getEntries();
    setState(() {
      _entries = entries;
    });
  }

  Future<void> _deleteEntry(String entryId) async {
    await _databaseService.deleteEntry(entryId);
    _fetchEntries(); // Refresh the list after deletion
  }

  void _showDeleteConfirmationDialog(String entryId) async {
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
      _deleteEntry(entryId);
    }
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          const GradientBg(),
          Center(
              child: _entries.isEmpty
                  ? const Text(
                      'Hello My Journal!',
                      style: TextStyle(color: Color(0xFF2F4F4F)),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          itemCount: _entries.length,
                          itemBuilder: (context, index) {
                            final entry = _entries[index];
                            return GestureDetector(
                              onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        JournalEntryDetails(entry: entry),
                                  ),
                                ),
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                entry['title'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall,
                                              ),
                                              Text(
                                                entry['createdDate'].toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                              Text(
                                                "${entry['content'].toString().substring(0, math.min(entry['content'].toString().length, 130))}...",
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () =>
                                              _showDeleteConfirmationDialog(
                                                  entry['id']),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    )),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GeminiChat(),
            ),
          ),
        },
        tooltip: 'Chat',
        backgroundColor: const Color(0xFFE0F7FA),
        child: const Icon(Icons.message),
      ),
    );
  }
}
