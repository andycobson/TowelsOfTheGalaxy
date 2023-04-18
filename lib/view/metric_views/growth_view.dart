import 'dart:developer';

import 'package:baby_tracks/component/decimal_number_input.dart';
import 'package:baby_tracks/component/text_divider.dart';
import 'package:baby_tracks/model/GrowthMetricModel.dart';
import 'package:baby_tracks/model/persistentUser.dart';
import 'package:baby_tracks/service/database.dart';
import 'package:flutter/material.dart';
import 'package:baby_tracks/constants/palette.dart';
import 'package:optional/optional.dart';

import '../../wrapperClasses/pair.dart';

class GrowthView extends StatefulWidget {
  late Optional model;

  GrowthView(Optional arg, {super.key}) {
    model = arg;
  }

  @override
  State<GrowthView> createState() => _GrowthViewState();
}

class _GrowthViewState extends State<GrowthView> {
  String id = "";
  int isUpdate = 0;
  TimeOfDay time = TimeOfDay.now();
  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  static const List<String> lengthList = <String>['cm', 'in'];
  static const List<String> weightList = <String>['lb', 'kg'];
  String lengthDropDown = lengthList.first;
  String weightDropDown = weightList.first;

  String note = "";
  String weight = "";
  String height = "";
  String headCircumference = "";
  String babyId = "";
  String babyName = "Sam";

  late final TextEditingController _weight;
  late final TextEditingController _height;
  late final TextEditingController _headCircumference;
  late final TextEditingController _note;
  late final ScrollController _noteScroller;

  late final DatabaseService _service;

  @override
  void initState() {
    _weight = TextEditingController();
    _height = TextEditingController();
    _headCircumference = TextEditingController();
    _note = TextEditingController();
    _noteScroller = ScrollController();
    _service = DatabaseService();

    babyName = PersistentUser.instance.currentBabyName;
    babyId = PersistentUser.instance.userId;

    if (!widget.model.isPresent) {
      log("create");
    } else {
      Pair idModelPair = (widget.model.value as Pair);
      GrowthMetricModel modelToUpdate = idModelPair.right;
      Map<String, dynamic> modelJson = modelToUpdate.toJson();
      id = idModelPair.left;
      _weight.text = modelJson['weight'];
      _height.text = modelJson['height'];
      _headCircumference.text = modelJson['headCircumference'];
      _note.text = modelJson['notes'];
      isUpdate = 1;
    }

    super.initState();
  }

  @override
  void dispose() {
    _weight.dispose();
    _height.dispose();
    _headCircumference.dispose();
    _note.dispose();
    _noteScroller.dispose();
    super.dispose();
  }

  Future createInstance() async {
    note = _note.text;
    weight = _weight.text;
    height = _height.text;
    headCircumference = _headCircumference.text;

    DateTime when =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    GrowthMetricModel model = GrowthMetricModel(
        babyId: "$babyId#$babyName",
        timeCreated: when,
        height: height,
        weight: weight,
        headCircumference: headCircumference,
        notes: note);

    if (isUpdate == 0) {
      await _service.createGrowthMetric(model);
      Navigator.pop(context);
    } else {
      log("should Edit");
      await _service.editGrowthMetric(model, id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Growth'),
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
                  TextButton(
                    child: Text(
                      time.format(context),
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
              const TextDivider(text: 'Weight'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DecimalInput(controller: _weight),
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
                        value: weightDropDown,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: ColorPalette.background),
                        onChanged: (String? value) {
                          setState(() {
                            weightDropDown = value!;
                          });
                        },
                        items: weightList
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
              const TextDivider(text: 'Height'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DecimalInput(controller: _height),
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
                        value: lengthDropDown,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: ColorPalette.background),
                        onChanged: (String? value) {
                          setState(() {
                            lengthDropDown = value!;
                          });
                        },
                        items: lengthList
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
              const TextDivider(text: 'Head Circumference'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DecimalInput(controller: _headCircumference),
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
                        value: lengthDropDown,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: ColorPalette.background),
                        onChanged: (String? value) {
                          setState(() {
                            lengthDropDown = value!;
                          });
                        },
                        items: lengthList
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
              ), //
            ],
          ),
        ),
      ),
    );
  }
}
