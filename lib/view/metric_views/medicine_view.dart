import 'package:baby_tracks/component/date_timepicker.dart';
import 'package:baby_tracks/component/notes_input.dart';
import 'package:baby_tracks/component/text_divider.dart';
import 'package:baby_tracks/constants/palette.dart';
import 'package:baby_tracks/model/persistent_user.dart';
import 'package:baby_tracks/service/database.dart';
import 'package:baby_tracks/model/medicine_metric_model.dart';
import 'package:baby_tracks/wrapperClasses/datetime_wrap.dart';

import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../../component/decimal_number_input.dart';
import '../../wrapperClasses/pair.dart';

class MedicineView extends StatefulWidget {
  late final Optional model;

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
  DateTime date = DateTime.now();
  late DateTimeWrapper startTimeWrapper;

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

    if (widget.model.isPresent) {
      isUpdate = 1;
      Pair idModelPair = (widget.model.value as Pair);
      MedicineMetricModel modelToUpdate = idModelPair.right;
      id = idModelPair.left;
      Map<String, dynamic> modelJson = modelToUpdate.toJson();
      _note.text = modelJson['notes'];
      _dose.text = modelJson['dose'];
      _medName.text = modelJson['medicineName'];
      time = TimeOfDay.fromDateTime(modelJson['startTime']);
      date = modelJson['startTime'];
    }

    startTimeWrapper = DateTimeWrapper(date, time);

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

    DateTime when = DateTime(
        startTimeWrapper.dateValue.year,
        startTimeWrapper.dateValue.month,
        startTimeWrapper.dateValue.day,
        startTimeWrapper.timeValue.hour,
        startTimeWrapper.timeValue.minute);

    DateTime now = DateTime.now();

    MedicineMetricModel model = MedicineMetricModel(
        babyId: "$babyId#$babyName",
        timeCreated: now,
        startTime: when,
        dose: doseAmount,
        medicineName: medicineName,
        notes: notes);

    if (isUpdate == 0) {
      await _service.createMedicineMetric(model);
    } else {
      await _service.editMedicineMetric(model, id);
    }
    if (context.mounted) Navigator.of(context).pop();
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
                  DateTimePicker(dateTime: startTimeWrapper),
                ],
              ),
              const TextDivider(text: 'Amount'),
              const SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                DecimalInput(controller: _dose),
                const Text('ml', style: TextStyle(color: Colors.white)),
              ]),
              const SizedBox(
                height: 20,
              ),
              const TextDivider(text: 'Notes'),
              const SizedBox(
                height: 20,
              ),
              NotesInput(
                  scrollController: _noteScroller, editingController: _note),
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
