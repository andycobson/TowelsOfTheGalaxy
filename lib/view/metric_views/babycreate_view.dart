import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:baby_tracks/constants/palette.dart';

class BabyCreateView extends StatefulWidget {
  const BabyCreateView({super.key});

  @override
  State<BabyCreateView> createState() => _BabyCreateViewState();
}

class _BabyCreateViewState extends State<BabyCreateView> {
  TimeOfDay time = TimeOfDay.now();
  static const List<String> list = <String>['Boy', 'Girl'];
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Baby+'),
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
                  'Name',
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
              height: 50,
              child: Column(
                children: const [
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        color: ColorPalette.lightAccent,
                      ),
                      decoration: InputDecoration(labelText: 'Enter Baby Name'),
                      keyboardType: TextInputType.name,
                      maxLines: null,
                      expands: true, // <-- SEE HERE
                    ),
                  ),
                ],
              ),
            ),
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text(
                  'Birthday',
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: []),
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
                  'Gender',
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
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: ColorPalette.background),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// class _BabyCreateViewState extends State<BabyCreateView> {
// TimeOfDay time = TimeOfDay.now();
// }
