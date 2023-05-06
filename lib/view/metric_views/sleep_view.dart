import 'dart:developer';

import 'package:baby_tracks/component/date_timepicker.dart';
import 'package:baby_tracks/component/notes_input.dart';
import 'package:baby_tracks/component/text_divider.dart';
import 'package:baby_tracks/model/sleep_metric_model.dart';
import 'package:baby_tracks/model/persistent_user.dart';
import 'package:baby_tracks/service/database.dart';
import 'package:baby_tracks/wrapperClasses/datetime_wrap.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracks/constants/palette.dart';
import 'package:optional/optional.dart';

import '../../wrapperClasses/pair.dart';

class SleepView extends StatefulWidget {
  late final Optional model;

  SleepView(Optional arg, {super.key}) {
    model = arg;
  }

  @override
  State<SleepView> createState() => _SleepViewState();
}

class _SleepViewState extends State<SleepView> {
  String id = "";
  int isUpdate = 0;
  TimeOfDay startTime = TimeOfDay.now();
  DateTime startDate = DateTime.now();
  late DateTimeWrapper startTimeWrapper;
  TimeOfDay endTime = TimeOfDay.now();
  DateTime endDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  late DateTimeWrapper endTimeWrapper;

  String note = "";
  String babyId = "";
  String babyName = "Sam";

  late final TextEditingController _note;
  late final ScrollController _noteScroller;

  late final DatabaseService _service;

  @override
  void initState() {
    _note = TextEditingController();
    _noteScroller = ScrollController();
    _service = DatabaseService();

    babyName = PersistentUser.instance.currentBabyName;
    babyId = PersistentUser.instance.userId;

    if (widget.model.isPresent) {
      Pair idModelPair = (widget.model.value as Pair);
      SleepMetricModel modelToUpdate = idModelPair.right;
      Map<String, dynamic> modelJson = modelToUpdate.toJson();
      startTime = TimeOfDay.fromDateTime(modelJson['startTime']);
      startDate = modelJson['startTime'];
      endTime = TimeOfDay.fromDateTime(modelJson['endTime']);
      endDate = modelJson['endTime'];
      _note.text = modelJson['notes'];
      id = idModelPair.left;
      isUpdate = 1;
    }

    startTimeWrapper = DateTimeWrapper(startDate, startTime);
    endTimeWrapper = DateTimeWrapper(endDate, endTime);

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
    DateTime when = DateTime.now();
    DateTime start = DateTime(
        startTimeWrapper.dateValue.year,
        startTimeWrapper.dateValue.month,
        startTimeWrapper.dateValue.day,
        startTimeWrapper.timeValue.hour,
        startTimeWrapper.timeValue.minute);
    DateTime end = DateTime(
        endTimeWrapper.dateValue.year,
        endTimeWrapper.dateValue.month,
        endTimeWrapper.dateValue.day,
        endTimeWrapper.timeValue.hour,
        endTimeWrapper.timeValue.minute);
    Duration durationTime = end.difference(start);
    String duration = ((durationTime.inMinutes) / 60).toString();
    SleepMetricModel model = SleepMetricModel(
        babyId: "$babyId#$babyName",
        timeCreated: when,
        startTime: start,
        endTime: end,
        duration: duration,
        notes: note);

    if (isUpdate == 0) {
      await _service.createSleepMetric(model);
    } else {
      await _service.editSleepMetric(model, id);
    }
    if (context.mounted) Navigator.of(context).pop();
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
                  DateTimePicker(dateTime: startTimeWrapper),
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
                  DateTimePicker(dateTime: endTimeWrapper),
                ],
              ),
              const TextDivider(text: 'Notes'),
              NotesInput(
                  scrollController: _noteScroller, editingController: _note),
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
