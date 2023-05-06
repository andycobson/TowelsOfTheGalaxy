import 'package:baby_tracks/component/date_timepicker.dart';
import 'package:baby_tracks/component/notes_input.dart';
import 'package:baby_tracks/component/text_divider.dart';
import 'package:baby_tracks/constants/palette.dart';
import 'package:baby_tracks/model/throwup_metric_model.dart';
import 'package:baby_tracks/model/persistent_user.dart';
import 'package:baby_tracks/service/database.dart';
import 'package:baby_tracks/wrapperClasses/datetime_wrap.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../../wrapperClasses/pair.dart';

class ThrowUpView extends StatefulWidget {
  late final Optional model;

  ThrowUpView(Optional arg, {super.key}) {
    model = arg;
  }

  @override
  State<ThrowUpView> createState() => _ThrowUpViewState();
}

class _ThrowUpViewState extends State<ThrowUpView> {
  String id = "";
  int isUpdate = 0;
  TimeOfDay time = TimeOfDay.now();
  DateTime date = DateTime.now();
  late DateTimeWrapper startTimeWrapper;

  String notes = "";
  String amount = "";
  String throwUpColor = "";
  String babyId = "";
  String babyName = "";
  static const List<String> amountList = <String>[
    'A lot',
    'Slightly above normal',
    'Normal amount',
    'Slightly below normal',
    'A little'
  ];

  String dropdownAmountValue = amountList.first;

  late final TextEditingController _note;
  late final TextEditingController _color;
  late final TextEditingController _amount;
  late final ScrollController _noteScroller;
  late final ScrollController _colorScroller;

  late final DatabaseService _service;

  @override
  void initState() {
    _note = TextEditingController();
    _color = TextEditingController();
    _noteScroller = ScrollController();
    _colorScroller = ScrollController();
    _amount = TextEditingController();
    _service = DatabaseService();

    babyName = PersistentUser.instance.currentBabyName;
    babyId = PersistentUser.instance.userId;

    if (widget.model.isPresent) {
      isUpdate = 1;
      Pair idModelPair = (widget.model.value as Pair);
      ThrowUpMetricModel modelToUpdate = idModelPair.right;
      Map<String, dynamic> modelJson = modelToUpdate.toJson();
      time = TimeOfDay.fromDateTime(modelJson['startTime']);
      date = modelJson['startTime'];
      _color.text = modelJson['throwUpColor'];
      dropdownAmountValue = modelJson['amount'];
      _note.text = modelJson['notes'];
      id = idModelPair.left;
    }

    startTimeWrapper = DateTimeWrapper(date, time);

    super.initState();
  }

  @override
  void dispose() {
    _note.dispose();
    _noteScroller.dispose();
    _colorScroller.dispose();
    _amount.dispose();
    super.dispose();
  }

  Future createInstance() async {
    notes = _note.text;
    amount = dropdownAmountValue;
    throwUpColor = _color.text;

    DateTime when = DateTime.now();
    DateTime startTime = DateTime(
        startTimeWrapper.dateValue.year,
        startTimeWrapper.dateValue.month,
        startTimeWrapper.dateValue.day,
        startTimeWrapper.timeValue.hour,
        startTimeWrapper.timeValue.minute);
    ThrowUpMetricModel model = ThrowUpMetricModel(
        babyId: "$babyId#$babyName",
        timeCreated: when,
        startTime: startTime,
        throwUpColor: throwUpColor,
        amount: amount,
        notes: notes);

    if (isUpdate == 0) {
      await _service.createThrowUpMetric(model);
    } else {
      await _service.editThrowUpMetric(model, id);
    }
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ThrowUp'),
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
              const TextDivider(text: 'Color'),
              SizedBox(
                height: 100,
                child: Scrollbar(
                  controller: _colorScroller,
                  child: TextField(
                    style: const TextStyle(color: Colors.black),
                    scrollController: _colorScroller,
                    autofocus: false,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _color,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: 'Enter Color',
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ),
              const TextDivider(text: 'Amount'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 0.80),
                    ),
                    child: Center(
                      child: DropdownButton<String>(
                        value: dropdownAmountValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: ColorPalette.background),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownAmountValue = value!;
                          });
                        },
                        items: amountList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
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
              ), //
            ],
          ),
        ),
      ),
    );
  }
}
