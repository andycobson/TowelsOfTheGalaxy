import 'dart:developer';

import 'package:baby_tracks/component/decimal_number_input.dart';
import 'package:baby_tracks/component/text_divider.dart';
import 'package:baby_tracks/component/toggle_bar.dart';
import 'package:baby_tracks/model/food_metric_model.dart';
import 'package:baby_tracks/model/persistent_user.dart';
import 'package:baby_tracks/service/database.dart';
import 'package:baby_tracks/wrapperClasses/datetime_wrap.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional_internal.dart';
import '../../component/date_timepicker.dart';
import '../../constants/palette.dart';
import '../../wrapperClasses/pair.dart';

class FoodView extends StatefulWidget {
  late final Optional model;

  FoodView(Optional arg, {super.key}) {
    model = arg;
  }

  @override
  State<FoodView> createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView> {
  String id = "";
  int isUpdate = 0;
  TimeOfDay time = TimeOfDay.now();
  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  static const List<String> metricTypeList = <String>['oz', 'ml'];

  DateTime thisDate = DateTime.now();
  List<String> labels = ['Bottle', 'Nursing'];

  int counter = 0;

  StringWrapper dropdownMetricValue = StringWrapper(metricTypeList.first);
  late DateTimeWrapper bottleTimeWrapper;
  String note = "";
  String duration = "";
  String amount = "";
  String feedingType = "";
  String babyId = "";
  String babyName = "Sam";
  String metricType = "";

  TimeOfDay nursingStartTimeOfDay = TimeOfDay.now();
  TimeOfDay nursingEndTimeOfDay = TimeOfDay.now();
  DateTime nursingStartDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime nursingEndDateTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  late DateTimeWrapper nursingStartTime;
  late DateTimeWrapper nursingEndTime;

  late final TextEditingController _amount;
  late final TextEditingController durationController;
  late final TextEditingController nursingNote;
  late final TextEditingController bottleNote;

  late final DatabaseService _service;

  late List<Widget> widgets;

  @override
  void initState() {
    _amount = TextEditingController();
    durationController = TextEditingController();
    _service = DatabaseService();
    nursingNote = TextEditingController();
    bottleNote = TextEditingController();
    bottleTimeWrapper = DateTimeWrapper(thisDate, time);

    babyName = PersistentUser.instance.currentBabyName;
    babyId = PersistentUser.instance.userId;

    if (widget.model.isPresent) {
      Pair idModelPair = (widget.model.value as Pair);
      FoodMetricModel modelToUpdate = idModelPair.right;
      id = idModelPair.left;
      Map<String, dynamic> modelJson = modelToUpdate.toJson();

      if (modelJson['feedingType'] == "Nursing") {
        counter = 1;
        nursingNote.text = modelJson['notes'];
        nursingStartTimeOfDay = TimeOfDay.fromDateTime(modelJson['startTime']);
        nursingEndTimeOfDay = TimeOfDay.fromDateTime(modelJson['endTime']);
        nursingStartDateTime = modelJson['startTime'];
        nursingEndDateTime = modelJson['endTime'];
      } else {
        bottleNote.text = modelJson['notes'];
        time = TimeOfDay.fromDateTime(modelJson['startTime']);
        thisDate = modelJson['startTime'];
      }
      nursingStartTime =
          DateTimeWrapper(nursingStartDateTime, nursingStartTimeOfDay);
      nursingEndTime = DateTimeWrapper(nursingEndDateTime, nursingEndTimeOfDay);
      bottleTimeWrapper = DateTimeWrapper(thisDate, time);
      dropdownMetricValue.value = modelJson['metricType'];
      _amount.text = modelJson['amount'].toString();
      durationController.text = modelJson['duration'].toString();
      isUpdate = 1;
    }

    widgets = [
      BottleView(
        amount: _amount,
        note: bottleNote,
        metricTypeList: metricTypeList,
        dropDownWrapper: dropdownMetricValue,
        timeWrapper: bottleTimeWrapper,
      ),
      NursingView(
        note: nursingNote,
        startTime: nursingStartTime,
        endTime: nursingEndTime,
        duration: durationController,
      )
    ];

    super.initState();
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future createInstance() async {
    feedingType = labels[counter];
    metricType = dropdownMetricValue.value;
    DateTime when =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    DateTime startDateTime;
    DateTime endDateTime;

    if (feedingType == 'Bottle') {
      amount = _amount.text;
      note = bottleNote.text;
      duration = "0";
      startDateTime = DateTime(
          bottleTimeWrapper.dateValue.year,
          bottleTimeWrapper.dateValue.month,
          bottleTimeWrapper.dateValue.day,
          bottleTimeWrapper.timeValue.hour,
          bottleTimeWrapper.timeValue.minute);
      endDateTime = startDateTime;
    } else {
      amount = "0";
      note = nursingNote.text;
      duration = durationController.text;
      startDateTime = DateTime(
          nursingStartTime.dateValue.year,
          nursingStartTime.dateValue.month,
          nursingStartTime.dateValue.day,
          nursingStartTime.timeValue.hour,
          nursingStartTime.timeValue.minute);
      endDateTime = DateTime(
          nursingEndTime.dateValue.year,
          nursingEndTime.dateValue.month,
          nursingEndTime.dateValue.day,
          nursingEndTime.timeValue.hour,
          nursingEndTime.timeValue.minute);
    }

    FoodMetricModel model = FoodMetricModel(
        babyId: "$babyId#$babyName",
        timeCreated: when,
        startTime: startDateTime,
        endTime: endDateTime,
        feedingType: feedingType,
        metricType: metricType,
        amount: amount,
        duration: duration,
        notes: note);

    if (isUpdate == 0) {
      await _service.createFoodMetric(model);
    } else {
      await _service.editFoodMetric(model, id);
    }
    if (context.mounted) Navigator.of(context).pop();
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
              SizedBox(
                width: MediaQuery.of(context).size.width - 128,
                child: ToggleBar(
                  labels: labels,
                  textColor: ColorPalette.backgroundRGB,
                  backgroundBorder: Border.all(color: ColorPalette.lightAccent),
                  backgroundColor: ColorPalette.lightAccent,
                  selectedTabColor: ColorPalette.backgroundRGB,
                  labelTextStyle: const TextStyle(fontWeight: FontWeight.bold),
                  borderPadding: 1.0,
                  edgeAdjustment: 4,
                  onSelectionUpdated: (index) {
                    setState(() {
                      counter = index;
                    });
                  },
                ),
              ),
              widgets[counter],
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

class BottleView extends StatefulWidget {
  final TextEditingController amount;

  final TextEditingController note;

  final StringWrapper dropDownWrapper;

  final DateTimeWrapper timeWrapper;

  final List<String> metricTypeList;

  const BottleView(
      {required this.amount,
      required this.note,
      required this.dropDownWrapper,
      required this.timeWrapper,
      required this.metricTypeList,
      super.key});

  @override
  State<BottleView> createState() => _BottleViewState();
}

class _BottleViewState extends State<BottleView> {
  late ScrollController _noteScroller;

  @override
  void initState() {
    _noteScroller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _noteScroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextDivider(text: 'Amount'),
        const SizedBox(
          height: 20,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          DecimalInput(controller: widget.amount),
          Container(
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  color: Colors.black, style: BorderStyle.solid, width: 0.80),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Colors.black, style: BorderStyle.solid, width: 0.80),
              ),
              child: Center(
                child: DropdownButton<String>(
                  value: widget.dropDownWrapper.value,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: ColorPalette.background),
                  onChanged: (String? value) {
                    setState(() {
                      widget.dropDownWrapper.value = value!;
                    });
                  },
                  items: widget.metricTypeList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
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
            const Text(
              'Start Time',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            DateTimePicker(dateTime: widget.timeWrapper),
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
              controller: widget.note,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Add notes',
                contentPadding: EdgeInsets.all(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NursingView extends StatefulWidget {
  final TextEditingController note;
  final DateTimeWrapper startTime;
  final DateTimeWrapper endTime;
  final TextEditingController duration;

  const NursingView(
      {required this.note,
      required this.startTime,
      required this.endTime,
      required this.duration,
      super.key});

  @override
  State<NursingView> createState() => _NursingViewState();
}

class _NursingViewState extends State<NursingView> {
  late ScrollController _noteScroller;

  @override
  void initState() {
    _noteScroller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _noteScroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TextDivider(text: 'Time'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Nursing Start Time',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            DateTimePicker(dateTime: widget.startTime),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Nursing End Time',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            DateTimePicker(dateTime: widget.endTime),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Nursing Duration in Minutes',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            DecimalInput(controller: widget.duration),
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
              controller: widget.note,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Add notes',
                contentPadding: EdgeInsets.all(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StringWrapper {
  String value;
  StringWrapper(this.value);
}

class TimeWrapper {
  TimeOfDay value;
  TimeWrapper(this.value);
}
