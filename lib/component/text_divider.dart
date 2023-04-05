import 'package:flutter/material.dart';
import '../../constants/palette.dart';

class TextDivider extends StatelessWidget {
  const TextDivider({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
              color: ColorPalette.lightAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 20,
        ),
        const Expanded(
          child: Divider(
            color: ColorPalette.lightAccent,
            thickness: 2.0,
          ),
        ),
      ],
    );
  }
}
