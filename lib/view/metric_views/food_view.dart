import 'package:baby_tracks/component/decimal_number_input.dart';
import 'package:baby_tracks/component/text_divider.dart';
import 'package:baby_tracks/model/AppUser.dart';
import 'package:baby_tracks/model/FoodMetricModel.dart';
import 'package:baby_tracks/service/auth.dart';
import 'package:baby_tracks/service/database.dart';
import 'package:flutter/material.dart';
import '../../constants/palette.dart';

class FoodView extends StatefulWidget {
  const FoodView({super.key});

  @override
  State<FoodView> createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView> {
  TimeOfDay time = TimeOfDay.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  static const List<String> metricTypeList = <String>['oz', 'ml'];
  static const List<String> feedingTypeList = <String>[
    'Nursing',
    'Feeding',
    'Both'
  ];
  String dropdownMetricValue = metricTypeList.first;
  String dropdownFoodValue = feedingTypeList.first;
  String note = "";
  String duration = "";
  String amount = "";
  String feedingType = "";
  String babyId = "";
  String metricType = "";

  late final TextEditingController _amount;
  late final TextEditingController _feedingType;
  late final TextEditingController _duration;
  late final TextEditingController _note;
  late final ScrollController _noteScroller;

  late final AuthService _auth;
  late final DatabaseService _service;

  @override
  void initState() {
    _amount = TextEditingController();
    _feedingType = TextEditingController();
    _duration = TextEditingController();
    _note = TextEditingController();
    _noteScroller = ScrollController();
    _auth = AuthService();
    _service = DatabaseService();

    AppUser? user = _auth.currentUser;
    if (user != null) {
      babyId = user.uid;
    }

    super.initState();
  }

  @override
  void dispose() {
    _amount.dispose();
    _feedingType.dispose();
    _duration.dispose();
    _note.dispose();
    _noteScroller.dispose();
    super.dispose();
  }

  Future createInstance() async {
    note = _note.text;
    feedingType = dropdownFoodValue;
    metricType = dropdownMetricValue;
    amount = _amount.text;
    duration = _duration.text;
    DateTime when =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    DateTime startDateTime = DateTime(
        date.year, date.month, date.day, startTime.hour, startTime.minute);
    DateTime endDateTime =
        DateTime(date.year, date.month, date.day, endTime.hour, endTime.minute);
    FoodMetricModel model = FoodMetricModel(
        babyId: babyId,
        timeCreated: when,
        startTime: startDateTime,
        endTime: endDateTime,
        feedingType: feedingType,
        metricType: metricType,
        amount: amount,
        duration: duration,
        notes: note);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Alert"),
        content: const Text("Data submitted!"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              color: Colors.green,
              padding: const EdgeInsets.all(14),
              child: const Text("okay"),
            ),
          ),
        ],
      ),
    );

    await _service.updateFooodMetric(model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food'),
        backgroundColor: ColorPalette.backgroundRGB,
        elevation: 0,
      ),
      backgroundColor: ColorPalette.backgroundRGB,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 40.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const TextDivider(text: 'Amount'),
              const SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                DecimalInput(controller: _amount),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 0.80),
                  ),
                  child: DropdownButton<String>(
                    value: dropdownMetricValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: ColorPalette.background),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownMetricValue = value!;
                      });
                    },
                    items: metricTypeList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ]),
              const SizedBox(
                height: 20,
              ),
              const TextDivider(text: 'Time'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Nursing Start Time'),
                  TextButton(
                    child: Text(
                      startTime.format(context),
                    ),
                    onPressed: () async {
                      TimeOfDay? newTime = await showTimePicker(
                          context: context, initialTime: startTime);

                      if (newTime == null) return;

                      setState(() {
                        startTime = newTime;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Nursing End Timet'),
                  TextButton(
                    child: Text(
                      endTime.format(context),
                    ),
                    onPressed: () async {
                      TimeOfDay? newTime = await showTimePicker(
                          context: context, initialTime: endTime);

                      if (newTime == null) return;

                      setState(() {
                        endTime = newTime;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Nursing Duration in Minutes'),
                  DecimalInput(controller: _duration),
                ],
              ),
              const TextDivider(text: 'Feeding Type'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<String>(
                    value: dropdownFoodValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: ColorPalette.background),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownFoodValue = value!;
                      });
                    },
                    items: feedingTypeList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const TextDivider(text: 'Notes'),
              SizedBox(
                height: 100,
                child: Scrollbar(
                  controller: _noteScroller,
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    scrollController: _noteScroller,
                    autofocus: false,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _note,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Add notes',
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                width: 425,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
                  onPressed: () async {
                    createInstance();
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
