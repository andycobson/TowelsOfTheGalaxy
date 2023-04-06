import 'package:baby_tracks/component/text_divider.dart';
import 'package:baby_tracks/constants/palette.dart';
import 'package:baby_tracks/model/AppUser.dart';
import 'package:baby_tracks/model/DiaperMetricModel.dart';
import 'package:baby_tracks/service/auth.dart';
import 'package:baby_tracks/service/database.dart';
import 'package:flutter/material.dart';

class DiaperView extends StatefulWidget {
  const DiaperView({super.key});

  @override
  State<DiaperView> createState() => _DiaperViewState();
}

class _DiaperViewState extends State<DiaperView> {
  TimeOfDay time = TimeOfDay.now();
  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  static const List<String> list = <String>['Pee', 'Poo', 'Both'];
  String dropdownValue = list.first;

  String notes = "";
  String diaperContents = "";
  String babyId = "";

  late final TextEditingController _note;
  late final ScrollController _noteScroller;

  late final AuthService _auth;
  late final DatabaseService _service;

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
    notes = _note.text;
    diaperContents = dropdownValue;

    DateTime when =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    DiaperMetricModel model = DiaperMetricModel(
        babyId: babyId,
        timeCreated: when,
        startTime: when,
        diaperContents: diaperContents,
        notes: notes);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Alert"),
        content: const Text("Data submitted!"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Container(
              color: Colors.green,
              padding: const EdgeInsets.all(14),
              child: const Text("okay"),
            ),
          ),
        ],
      ),
    );

    await _service.createDiaperMetric(model);
    Navigator.pop(context);
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
              const TextDivider(text: 'Type'),
              DropdownButton<String>(
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
              ), //
            ],
          ),
        ),
      ),
    );
  }
}
