import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants/palette.dart';

class FoodView extends StatefulWidget {
  const FoodView({super.key});

  @override
  State<FoodView> createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView> {
  TimeOfDay time = TimeOfDay.now();
  static const List<String> list = <String>['oz', 'ml'];
  String dropdownValue = list.first;

  late final TextEditingController _amount;

  @override
  void initState() {
    _amount = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              children: const [
                Text(
                  'Amount',
                  style: TextStyle(
                    color: ColorPalette.lightAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Divider(
                    color: ColorPalette.lightAccent,
                    thickness: 2.0,
                  ),
                ),
              ],
            ),
            Row(children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                controller: _amount,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: '0.0',
                  hintStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 92, 92, 94),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 92, 92, 94),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
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
            ]),
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: const [
                Text(
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
                Expanded(
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
                  child: Text(
                    time.toString(),
                  ),
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
