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
      child: const Center(
        child: Text(
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
