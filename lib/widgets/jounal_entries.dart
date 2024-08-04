import 'package:flutter/material.dart';
import 'package:myapp/db/database_service.dart';
import 'package:myapp/widgets/background_gradient.dart';
import 'package:myapp/widgets/journal_entry_details.dart';

class JournalEntries extends StatefulWidget {
  const JournalEntries({super.key});
  @override
  State<JournalEntries> createState() => _JournalEntriesState();
}

class _JournalEntriesState extends State<JournalEntries> {
  final DatabaseEntryService _databaseService = DatabaseEntryService();
  List<Map<String, dynamic>> _entries = [];
  // List<JournalModel> entries = [];

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

  @override
  dispose() {
    //close the database
    // journalDb.close();
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
                                          "${entry['content'].toString().substring(0, 130)}...",
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
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        tooltip: 'Chat',
        backgroundColor: Color(0xFF87CEFA),
        child: Icon(Icons.message),
      ),
    );
  }
}
