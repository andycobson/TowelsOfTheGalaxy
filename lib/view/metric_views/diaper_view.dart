import 'dart:developer';

import 'package:baby_tracks/component/text_divider.dart';
import 'package:baby_tracks/constants/palette.dart';
import 'package:baby_tracks/model/diaper_metric_model.dart';
import 'package:baby_tracks/model/persistent_user.dart';
import 'package:baby_tracks/service/database.dart';

import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../../wrapperClasses/pair.dart';

class DiaperView extends StatefulWidget {
  late final Optional model;

  DiaperView(Optional arg, {super.key}) {
    model = arg;
  }

  @override
  State<DiaperView> createState() => _DiaperViewState();
}

class _DiaperViewState extends State<DiaperView> {
  String id = "";
  int isUpdate = 0;
  TimeOfDay time = TimeOfDay.now();

  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  static const List<String> list = <String>['Pee', 'Poo', 'Both'];
  static const List<String> dList = <String>['Small', 'Med', 'Large'];
  String dropdownValue = list.first;
  String diaperDropdownValue = dList.first;

  String notes = "";
  String diaperContents = "";
  String diaperSize = "";
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
      isUpdate = 1;
      Pair idModelPair = (widget.model.value as Pair);
      DiaperMetricModel modelToUpdate = idModelPair.right;
      id = idModelPair.left;
      Map<String, dynamic> modelJson = modelToUpdate.toJson();
      dropdownValue = modelJson['diaperContents'];
      diaperDropdownValue = modelJson['diaperSize'];
      _note.text = modelJson['notes'];
      time = TimeOfDay.fromDateTime(modelJson['startTime']);
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
    notes = _note.text;
    diaperContents = dropdownValue;
    diaperSize = diaperDropdownValue;

    DateTime when =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);

    DiaperMetricModel model = DiaperMetricModel(
        babyId: "$babyId#$babyName",
        timeCreated: when,
        startTime: when,
        diaperContents: diaperContents,
        diaperSize: diaperSize,
        notes: notes);

    if (isUpdate == 0) {
      await _service.createDiaperMetric(model);
    } else {
      await _service.editDiaperMetric(model, id);
    }
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diaper'),
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
              const TextDivider(text: 'Diaper Size'),
              Container(
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 0.80),
                ),
                child: Center(
                  child: DropdownButton<String>(
                    value: diaperDropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: ColorPalette.background),
                    onChanged: (String? value) {
                      setState(() {
                        diaperDropdownValue = value!;
                      });
                    },
                    items: dList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const TextDivider(text: 'Type'),
              Container(
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 0.80),
                ),
                child: Center(
                  child: DropdownButton<String>(
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
                ),
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
              const SizedBox(
                height: 20,
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
              //
            ],
          ),
        ),
      ),
    );
  }
}
