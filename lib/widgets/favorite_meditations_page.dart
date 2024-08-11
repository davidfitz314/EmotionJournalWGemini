import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/db/database_service.dart';
import 'package:myapp/widgets/background_gradient.dart';
import 'package:myapp/widgets/meditation_details_page.dart';

class FavoriteMeditationsPage extends ConsumerStatefulWidget {
  const FavoriteMeditationsPage({super.key});

  @override
  _FavoriteMeditationsPageState createState() =>
      _FavoriteMeditationsPageState();
}

class _FavoriteMeditationsPageState
    extends ConsumerState<FavoriteMeditationsPage> {
  late Future<List<Map<String, dynamic>>> _favoriteMeditations;

  @override
  void initState() {
    super.initState();
    _favoriteMeditations = _loadFavoriteMeditations();
  }

  Future<List<Map<String, dynamic>>> _loadFavoriteMeditations() async {
    final databaseService = DatabaseMeditationService();
    return databaseService.getEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GradientBg(),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _favoriteMeditations,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text('No favorite meditations found.'));
              } else {
                final entries = snapshot.data!;

                return ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final title = entry['title'] ?? 'No Title';
                    final steps = entry['steps'] as List<dynamic>? ?? [];
                    final preview =
                        steps.take(4).map((step) => step.toString()).join('\n');

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 5,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        subtitle: Text(
                          preview,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MeditationDetailsPage(
                                title: title,
                                meditationSteps:
                                    List<String>.from(entry['steps']),
                              ),
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            // Show a confirmation dialog
                            bool? confirmDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Delete Meditation'),
                                  content: Text(
                                      'Are you sure you want to delete this meditation?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmDelete == true) {
                              // Delete the entry from Firebase
                              final databaseService =
                                  DatabaseMeditationService();
                              await databaseService.deleteEntry(entry['id']);

                              // Refresh the list by reloading the data
                              setState(() {
                                _favoriteMeditations =
                                    _loadFavoriteMeditations();
                              });
                            }
                          },
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
