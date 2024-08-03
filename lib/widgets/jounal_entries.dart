import 'package:flutter/material.dart';
import 'package:myapp/db/journal_db.dart';
import 'package:myapp/db/journal_model.dart';
import 'package:myapp/widgets/background_gradient.dart';

class JournalEntries extends StatefulWidget {
  const JournalEntries({super.key});
  @override
  State<JournalEntries> createState() => _JournalEntriesState();
}

class _JournalEntriesState extends State<JournalEntries> {
  JournalDb journalDb = JournalDb.instance;

  List<JournalModel> entries = [];

  @override
  void initState() {
    refreshJournalEntries();
    super.initState();
  }

  @override
  dispose() {
    //close the database
    journalDb.close();
    super.dispose();
  }

  ///Gets all the entries from the database and updates the state
  refreshJournalEntries() {
    journalDb.readAll().then((value) {
      setState(() {
        entries = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          const GradientBg(),
          Center(
            child: entries.isEmpty
                ? const Text(
                    'Hello My Journal!',
                    style: TextStyle(color: Colors.white),
                  )
                : ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return GestureDetector(
                        onTap: () => {},
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    entry.createdDate.toString().split(' ')[0],
                                  ),
                                  Text(
                                    entry.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
          ),
        ]),
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        tooltip: 'Chat',
        child: Icon(Icons.message),
      ),
    );
  }
}
