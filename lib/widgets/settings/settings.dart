import 'package:flutter/material.dart';
import 'package:myapp/widgets/background_gradient.dart';
import 'package:myapp/widgets/settings/chat_selector.dart';
import 'package:myapp/widgets/settings/general_settings.dart';
import 'package:myapp/widgets/settings/meditation_selector.dart';
import 'package:myapp/widgets/settings/playback_settings.dart';
import 'package:myapp/widgets/settings/sub_title.dart';

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
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(children: const <Widget>[
              SubtitleWithLine(title: "Mindful ML Advisor"),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
                child: MeditationSelector(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
                child: ChatFocusSelector(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
                child: PlaybackSettingsPauseDuration(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 40, 30),
                child: PlaybackSettingsPitch(),
              ),
              SubtitleWithLine(title: "General Settings"),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: GeneralSettings(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                child: NotificationSettings(),
              ),
            ])));
  }
}
