import 'dart:developer';

import 'package:baby_tracks/component/text_divider.dart';
import 'package:baby_tracks/constants/palette.dart';
import 'package:baby_tracks/model/persistentUser.dart';
import 'package:baby_tracks/service/database.dart';
import 'package:baby_tracks/model/MedicineMetricModel.dart';

import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../../component/decimal_number_input.dart';
import '../../wrapperClasses/pair.dart';

class MedicineView extends StatefulWidget {
  late Optional model;

  MedicineView(Optional arg, {super.key}) {
    model = arg;
  }

  @override
  State<MedicineView> createState() => _MedicineViewState();
}

class _MedicineViewState extends State<MedicineView> {
  String id = "";
  int isUpdate = 0;
  TimeOfDay time = TimeOfDay.now();

  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  String notes = "";
  String babyId = "";
  String babyName = "Sam";
  String medicineName = "";
  String doseAmount = "";

  late final TextEditingController _note;
  late final TextEditingController _dose;
  late final ScrollController _noteScroller;
  late final TextEditingController _medName;
  late final DatabaseService _service;

  @override
  void initState() {
    _medName = TextEditingController();
    _note = TextEditingController();
    _noteScroller = ScrollController();
    _service = DatabaseService();
    _dose = TextEditingController();
    babyName = PersistentUser.instance.currentBabyName;
    babyId = PersistentUser.instance.userId;

    if (!widget.model.isPresent) {
      log("create");
    } else {
      isUpdate = 1;
      Pair idModelPair = (widget.model.value as Pair);
      MedicineMetricModel modelToUpdate = idModelPair.right;
      id = idModelPair.left;
      Map<String, dynamic> modelJson = modelToUpdate.toJson();
      _note.text = modelJson['notes'];
      time = TimeOfDay.fromDateTime(modelJson['Time Taken']);
    }

    super.initState();
  }

  @override
  void dispose() {
    _medName.dispose();
    _dose.dispose();
    _note.dispose();
    _noteScroller.dispose();
    super.dispose();
  }

  Future createInstance() async {
    notes = _note.text;
    doseAmount = _dose.text;
    medicineName = _medName.text;
    // diaperContents = dropdownValue;

    DateTime when =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);

    MedicineMetricModel model = MedicineMetricModel(
        babyId: "$babyId#$babyName",
        timeCreated: when,
        startTime: when,
        dose: doseAmount,
        medicineName: medicineName,
        notes: notes);

    if (isUpdate == 0) {
      await _service.createMedicineMetric(model);
    } else {
      log("should Edit");
      await _service.editMedicineMetric(model, id);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine'),
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
              const TextDivider(text: 'Medicine Name'),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 100,
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  autofocus: false,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _medName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Type Medicine Name Here',
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              const TextDivider(text: 'Time Taken'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Time:',
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
              const TextDivider(text: 'Amount'),
              const SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                DecimalInput(controller: _dose),
                Text('ml', style: const TextStyle(color: Colors.white)),
              ]),
              const SizedBox(
                height: 20,
              ),
              const TextDivider(text: 'Notes'),
              const SizedBox(
                height: 20,
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
