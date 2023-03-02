import 'package:baby_tracks/constants/palette.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorPalette.backgroundRGB,
        body: SizedBox.expand(
          child: Center(
            child: Container(
              child: Text(
                "Baby Tracks",
                style: TextStyle(
                  fontSize: 42,
                  color: ColorPalette.lightAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ));
  }
}
