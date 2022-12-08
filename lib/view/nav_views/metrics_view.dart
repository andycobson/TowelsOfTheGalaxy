import 'package:flutter/material.dart';

class AppMetricPage extends StatefulWidget {
  const AppMetricPage({super.key});

  @override
  State<AppMetricPage> createState() => _AppMetricPageState();
}

class _AppMetricPageState extends State<AppMetricPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: const Text(
          'Metrics - Coming Soon',
          style: TextStyle(
            fontSize: 28,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
