import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/db/database_service.dart';
import 'package:myapp/widgets/background_gradient.dart';
import 'package:myapp/widgets/meditation_details_page.dart';

class FavoriteMeditationsPage extends ConsumerWidget {
  const FavoriteMeditationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final databaseService = DatabaseMeditationService();

    return Scaffold(
      body: Stack(
        children: [
          const GradientBg(),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: databaseService.getEntries(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No favorite meditations found.'));
              } else {
                final entries = snapshot.data!;

                return ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final title = entry['title'] ??
                        'No Title'; // Use title from entry or default
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
                          // Handle tap to view full meditation steps, if desired
                        },
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
