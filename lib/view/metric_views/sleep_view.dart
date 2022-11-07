import 'package:flutter/material.dart';

class SleepView extends StatefulWidget {
  const SleepView({super.key});

  @override
  State<SleepView> createState() => _SleepViewState();
}

class _SleepViewState extends State<SleepView> {
  @override
  Widget build(BuildContext context) {
    return Container(child: const Text('Sleep'));
  }
}
