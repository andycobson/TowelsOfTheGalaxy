import 'dart:developer';

import 'package:baby_tracks/component/date_timepicker.dart';
import 'package:baby_tracks/component/decimal_number_input.dart';
import 'package:baby_tracks/component/notes_input.dart';
import 'package:baby_tracks/component/text_divider.dart';
import 'package:baby_tracks/model/temp_metric_model.dart';
import 'package:baby_tracks/model/persistent_user.dart';
import 'package:baby_tracks/service/database.dart';
import 'package:baby_tracks/wrapperClasses/datetime_wrap.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracks/constants/palette.dart';
import 'package:optional/optional.dart';

import '../../wrapperClasses/pair.dart';

class TemperatureView extends StatefulWidget {
  late final Optional model;

  TemperatureView(Optional arg, {super.key}) {
    model = arg;
  }

  @override
  State<TemperatureView> createState() => _TemperatureViewState();
}

class _TemperatureViewState extends State<TemperatureView> {
  String id = "";
  int isUpdate = 0;
  static const List<String> temperatureList = <String>['F', 'C'];
  String temperatureDropDown = temperatureList.first;

  TimeOfDay tempTime = TimeOfDay.now();
  DateTime tempDate = DateTime.now();
  late DateTimeWrapper tempTimeWrapper;

  String note = "";
  String babyId = "";
  String babyName = "Sam";
  String tempType = "";
  String temperature = "";

  late final TextEditingController _temperature;
  late final TextEditingController _note;
  late final ScrollController _noteScroller;
  late final DatabaseService _service;

  @override
  void initState() {
    _temperature = TextEditingController();
    _note = TextEditingController();
    _noteScroller = ScrollController();
    _service = DatabaseService();

    babyName = PersistentUser.instance.currentBabyName;
    babyId = PersistentUser.instance.userId;

    if (widget.model.isPresent) {
      isUpdate = 1;
      Pair idModelPair = (widget.model.value as Pair);
      TempMetricModel modelToUpdate = idModelPair.right;
      Map<String, dynamic> modelJson = modelToUpdate.toJson();
      tempTime = TimeOfDay.fromDateTime(modelJson['tempTime']);
      temperatureDropDown = modelJson['tempType'];
      _temperature.text = modelJson['temperature'].toString();
      _note.text = modelJson['notes'];
      tempDate = modelJson['tempTime'];
      id = idModelPair.left;
    }

    tempTimeWrapper = DateTimeWrapper(tempDate, tempTime);

    super.initState();
  }

  @override
  void dispose() {
    _temperature.dispose();
    _note.dispose();
    _noteScroller.dispose();
    super.dispose();
  }

  Future createInstance() async {
    note = _note.text;
    tempType = temperatureDropDown;
    temperature = _temperature.text;
    DateTime when = DateTime.now();
    DateTime start = DateTime(
        tempTimeWrapper.dateValue.year,
        tempTimeWrapper.dateValue.month,
        tempTimeWrapper.dateValue.day,
        tempTimeWrapper.timeValue.hour,
        tempTimeWrapper.timeValue.minute);
    TempMetricModel model = TempMetricModel(
        babyId: "$babyId#$babyName",
        timeCreated: when,
        tempTime: start,
        temperature: temperature,
        tempType: tempType,
        notes: note);

    if (isUpdate == 0) {
      await _service.createTemperatureMetric(model);
    } else {
      await _service.editTemperatureMetric(model, id);
    }
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature'),
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
                    'Time Temp was taken',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DateTimePicker(dateTime: tempTimeWrapper),
                ],
              ),

              const TextDivider(text: 'Temperature'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DecimalInput(controller: _temperature),
                  Container(
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 0.80),
                    ),
                    child: Center(
                      child: DropdownButton<String>(
                        value: temperatureDropDown,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: ColorPalette.background),
                        onChanged: (String? value) {
                          setState(() {
                            temperatureDropDown = value!;
                          });
                        },
                        items: temperatureList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  )
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
