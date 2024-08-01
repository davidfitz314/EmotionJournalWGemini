import 'package:flutter/material.dart';

class SubtitleWithLine extends StatelessWidget {
  final String title;

  const SubtitleWithLine({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
            height:
                4), // Optional: add some space between the title and the line
        const Row(
          children: <Widget>[
            Expanded(
              child: Divider(
                color: Color(0xFF2F4F4F),
                thickness: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
