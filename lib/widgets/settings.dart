import 'package:flutter/material.dart';
import 'package:myapp/widgets/background_gradient.dart';
import 'package:myapp/widgets/general_settings.dart';
import 'package:myapp/widgets/meditation_selector.dart';
import 'package:myapp/widgets/sub_title.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Stack(children: [
      GradientBg(),
      Center(
        child: SettingsList(),
      ),
    ]));
  }
}

class SettingsList extends StatelessWidget {
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2758149102.
  const SettingsList({super.key});

// Suggested code may be subject to a license. Learn more: ~LicenseLog:3258788030.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(children: const <Widget>[
              SubtitleWithLine(title: "Mindful ML Advisor"),
              MeditationSelector(),
              SubtitleWithLine(title: "General Settings"),
              GeneralSettings(),
              NotificationSettings(),
            ])));
  }
}
