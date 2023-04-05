import 'dart:developer';

import 'package:baby_tracks/component/text_divider.dart';
import 'package:baby_tracks/model/AppUser.dart';
import 'package:baby_tracks/model/SleepMetricModel.dart';
import 'package:baby_tracks/service/auth.dart';
import 'package:baby_tracks/service/database.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracks/constants/palette.dart';

class SleepView extends StatefulWidget {
  String id = "";

  SleepView(String arg) {
    id = arg;
  }

  @override
  State<SleepView> createState() => _SleepViewState(id);
}

class _SleepViewState extends State<SleepView> {
  String id = "";
  int isUpdate = 0;
  TimeOfDay time = TimeOfDay.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  String note = "";
  String babyId = "";

  late final TextEditingController _note;
  late final ScrollController _noteScroller;

  late final AuthService _auth;
  late final DatabaseService _service;

  _SleepViewState(String arg) {
    if (arg == "") {
      log("create");
    } else {
      id = arg;
      isUpdate = 1;
    }
  }

  @override
  void initState() {
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
    _note.dispose();
    _noteScroller.dispose();
    super.dispose();
  }

  Future createInstance() async {
    note = _note.text;
    DateTime when =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    DateTime start = DateTime(
        date.year, date.month, date.day, startTime.hour, startTime.minute);
    DateTime end =
        DateTime(date.year, date.month, date.day, endTime.hour, endTime.minute);
    Duration durationTime = end.difference(start);
    String duration = ((durationTime.inMinutes) / 60).toString();
    SleepMetricModel model = SleepMetricModel(
        babyId: babyId,
        timeCreated: when,
        startTime: start,
        endTime: end,
        duration: duration,
        notes: note);
    // showDialog(
    //   context: context,
    //   builder: (ctx) => AlertDialog(
    //     title: const Text("Alert"),
    //     content: const Text("Data submitted!"),
    //     actions: <Widget>[
    //       TextButton(
    //         onPressed: () {
    //           Navigator.of(ctx).pop();
    //         },
    //         child: Container(
    //           color: Colors.green,
    //           padding: const EdgeInsets.all(14),
    //           child: const Text("okay"),
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    if (isUpdate == 0) {
      await _service.createSleepMetric(model);
      Navigator.pop(context);
    } else {
      log("should Edit");
      await _service.editSleepMetric(model, id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep'),
        backgroundColor: ColorPalette.backgroundRGB,
        elevation: 0,
      ),
      backgroundColor: ColorPalette.backgroundRGB,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const TextDivider(text: 'Time'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Start Time',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    child: Text(startTime.format(context)),
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
                  const Text(
                    'End Time',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    child: Text(endTime.format(context)),
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
