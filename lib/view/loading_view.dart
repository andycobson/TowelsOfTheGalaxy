
import 'package:flutter/material.dart';

import '../constants/palette.dart';

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
