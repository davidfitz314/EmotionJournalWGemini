import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/widgets/favorite_meditations_page.dart';
import 'package:myapp/widgets/home.dart';
import 'package:myapp/widgets/jounal_entries.dart';
import 'package:myapp/widgets/settings/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(
      child: MyApp(
    selectedIndex: 0,
  )));
}

class MyApp extends StatefulWidget {
  final int selectedIndex;

  const MyApp({super.key, this.selectedIndex = 0});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        initialIndex: _currentIndex,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.menu_book)),
                Tab(icon: Icon(Icons.self_improvement)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
            title: const Text(
              'Mindful Moods',
              style: TextStyle(
                color: Color(0xFF2F4F4F),
                fontSize: 24,
                fontFamily: 'Nunito',
                fontFamilyFallback: ['OpenSans', 'Roboto'],
              ),
            ),
            backgroundColor: const Color(0xFFE0F7FA),
            foregroundColor: const Color(0xFF2F4F4F),
          ),
          body: const TabBarView(
            children: [
              Home(),
              JournalEntries(),
              FavoriteMeditationsPage(),
              SettingsPage(),
            ],
          ),
        ),
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF87CEFA)),
        useMaterial3: true,
      ),
    );
  }
}
