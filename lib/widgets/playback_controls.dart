import 'package:flutter/material.dart';

class PlaybackControls extends StatefulWidget {
  const PlaybackControls({super.key});

  @override
  State<PlaybackControls> createState() => _PlaybackControlsState();
}

class _PlaybackControlsState extends State<PlaybackControls> {
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3412490123.
  @override
  Widget build(BuildContext context) {
    return Row(
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3165201934.
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const Text(
            'Playback:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              backgroundColor: Color.fromARGB(0, 0, 0, 0),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.skip_previous),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            onPressed: () {},
          ),
        ]);
  }
}
