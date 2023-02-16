import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:baby_tracks/constants/palette.dart';

class SleepView extends StatefulWidget {
  const SleepView({super.key});

  @override
  State<SleepView> createState() => _SleepViewState();
}

class _SleepViewState extends State<SleepView> {
  TimeOfDay time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep'),
        backgroundColor: ColorPalette.backgroundRGB,
        elevation: 0,
      ),
      backgroundColor: ColorPalette.backgroundRGB,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
        child: Column(
          children: [
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text(
                  'Time',
                  style: TextStyle(
                    color: ColorPalette.lightAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                const Expanded(
                  child: Divider(
                    color: ColorPalette.lightAccent,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('End Time'),
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

            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text(
                  'Notes',
                  style: TextStyle(
                    color: ColorPalette.lightAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                const Expanded(
                  child: Divider(
                    color: ColorPalette.lightAccent,
                    thickness: 2.0,
                  ),
                ),
              ],
            ),
            Container(
              //This container's Send button only affects this container
              height: 300,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  const Expanded(
                    child: TextField(
                      style: TextStyle(
                        color: ColorPalette.lightAccent,
                      ),
                      decoration: InputDecoration(labelText: 'Enter Message'),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      expands: true, // <-- SEE HERE
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ],
              ),
            ) //
          ],
        ),
      ),
    );
  }
}
