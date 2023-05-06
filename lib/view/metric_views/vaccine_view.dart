import 'package:baby_tracks/component/date_timepicker.dart';
import 'package:baby_tracks/component/notes_input.dart';
import 'package:baby_tracks/component/text_divider.dart';
import 'package:baby_tracks/constants/palette.dart';
import 'package:baby_tracks/model/vaccine_metric_model.dart';
import 'package:baby_tracks/model/persistent_user.dart';
import 'package:baby_tracks/service/database.dart';
import 'package:baby_tracks/wrapperClasses/datetime_wrap.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../../component/decimal_number_input.dart';
import '../../wrapperClasses/pair.dart';

class VaccineView extends StatefulWidget {
  late final Optional model;

  VaccineView(Optional arg, {super.key}) {
    model = arg;
  }

  @override
  State<VaccineView> createState() => _VaccineViewState();
}

class _VaccineViewState extends State<VaccineView> {
  String id = "";
  int isUpdate = 0;
  TimeOfDay vaccineTime = TimeOfDay.now();
  DateTime date = DateTime.now();
  late DateTimeWrapper vaccineTimeWrapper;

  String notes = "";
  String vaccineName = "";
  String babyId = "";
  String babyName = "Sam";
  String series = "";

  late final TextEditingController _note;
  late final ScrollController _noteScroller;
  late final ScrollController _nameScroller;

  late final DatabaseService _service;
  late final TextEditingController _vaccine;
  late final TextEditingController _series;

  @override
  void initState() {
    _note = TextEditingController();
    _noteScroller = ScrollController();
    _nameScroller = ScrollController();
    _service = DatabaseService();
    _vaccine = TextEditingController();
    _series = TextEditingController();

    babyName = PersistentUser.instance.currentBabyName;
    babyId = PersistentUser.instance.userId;

    if (widget.model.isPresent) {
      isUpdate = 1;
      Pair idModelPair = (widget.model.value as Pair);
      VaccineMetricModel modelToUpdate = idModelPair.right;
      Map<String, dynamic> modelJson = modelToUpdate.toJson();
      vaccineTime = TimeOfDay.fromDateTime(modelJson['startTime']);
      date = modelJson['startTime'];
      _vaccine.text = modelJson['vaccine'];
      _series.text = modelJson['series'].toString();
      _note.text = modelJson['notes'];
      id = idModelPair.left;
    }

    vaccineTimeWrapper = DateTimeWrapper(date, vaccineTime);

    super.initState();
  }

  @override
  void dispose() {
    _note.dispose();
    _noteScroller.dispose();
    _nameScroller.dispose();
    _series.dispose();
    super.dispose();
  }

  Future createInstance() async {
    notes = _note.text;
    series = _series.text;
    vaccineName = _vaccine.text;

    DateTime when = DateTime.now();

    DateTime startTime = DateTime(
        vaccineTimeWrapper.dateValue.year,
        vaccineTimeWrapper.dateValue.month,
        vaccineTimeWrapper.dateValue.day,
        vaccineTimeWrapper.timeValue.hour,
        vaccineTimeWrapper.timeValue.minute);

    VaccineMetricModel model = VaccineMetricModel(
        babyId: "$babyId#$babyName",
        timeCreated: when,
        startTime: startTime,
        vaccine: vaccineName,
        series: series,
        notes: notes);

    if (isUpdate == 0) {
      await _service.createVaccineMetric(model);
    } else {
      await _service.editVaccineMetric(model, id);
    }
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vaccine'),
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
                    'Select Time',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DateTimePicker(dateTime: vaccineTimeWrapper),
                ],
              ),
              const TextDivider(text: 'Vaccine Name'),
              SizedBox(
                height: 100,
                child: Scrollbar(
                  controller: _nameScroller,
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    scrollController: _nameScroller,
                    autofocus: false,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _vaccine,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter vaccine name',
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ),

              const TextDivider(text: 'Enter Series'),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                DecimalInput(controller: _series),
              ]),
              const TextDivider(text: 'Notes'),
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
              ), //
            ],
          ),
        ),
      ),
    );
  }
}
