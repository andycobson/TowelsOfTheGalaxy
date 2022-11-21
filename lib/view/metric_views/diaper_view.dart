import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiaperView extends StatefulWidget {
  const DiaperView({super.key});

  @override
  State<DiaperView> createState() => _DiaperViewState();
}

class _DiaperViewState extends State<DiaperView> {
  TimeOfDay time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
        child: Column(
          children: [
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text('Time'),
                const Expanded(
                  child: Divider(
                    thickness: 2.0,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Start Time'),
                TextButton(
                  child: Text(time.toString()),
                  onPressed: () async {
                    TimeOfDay? newTime = await showTimePicker(
                        context: context, initialTime: time);

                    if (newTime == null) return;

                    setState(() {
                      time = newTime;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
