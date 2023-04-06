import 'package:baby_tracks/component/decimal_number_input.dart';
import 'package:baby_tracks/component/text_divider.dart';
import 'package:baby_tracks/component/toggle_bar.dart';
import 'package:baby_tracks/model/AppUser.dart';
import 'package:baby_tracks/model/FoodMetricModel.dart';
import 'package:baby_tracks/service/auth.dart';
import 'package:baby_tracks/service/database.dart';
import 'package:flutter/material.dart';
import '../../constants/palette.dart';

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  TimeOfDay time = TimeOfDay.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  static const List<String> metricTypeList = <String>['oz', 'ml'];

  StringWrapper dropdownMetricValue = StringWrapper(metricTypeList.first);
  late TimeWrapper timeWrapper;
  String note = "";
  String duration = "";
  String amount = "";
  String feedingType = "";
  String babyId = "";

  late final TextEditingController _amount;
  late final TextEditingController _feedingType;
  late final TextEditingController _duration;

  late final TextEditingController nursingNote;
  late final TextEditingController bottleNote;

  late final AuthService _auth;
  late final DatabaseService _service;

  late List<Widget> widgets;

  @override
  void initState() {
    _amount = TextEditingController();
    _feedingType = TextEditingController();
    _duration = TextEditingController();
    _auth = AuthService();
    _service = DatabaseService();
    nursingNote = TextEditingController();
    bottleNote = TextEditingController();
    timeWrapper = TimeWrapper(time);

    widgets = [
      BottleView(
        amount: _amount,
        note: bottleNote,
        metricTypeList: metricTypeList,
        dropDownWrapper: dropdownMetricValue,
        timeWrapper: timeWrapper,
      ),
      NursingView(note: nursingNote)
    ];

    AppUser? user = _auth.currentUser;
    if (user != null) {
      babyId = user.uid;
    }

    super.initState();
  }

  @override
  void dispose() {
    _amount.dispose();
    _feedingType.dispose();
    _duration.dispose();
    super.dispose();
  }

  List<String> labels = ['Bottle', 'Nursing'];

  int counter = 0;

  Future createInstance() async {
    note = nursingNote.text;
    amount = _amount.text;
    duration = _duration.text;
    DateTime when =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    DateTime startDateTime = DateTime(
        date.year, date.month, date.day, startTime.hour, startTime.minute);
    DateTime endDateTime =
        DateTime(date.year, date.month, date.day, endTime.hour, endTime.minute);
    FoodMetricModel model = FoodMetricModel(
        babyId: babyId,
        timeCreated: when,
        startTime: startDateTime,
        endTime: endDateTime,
        feedingType: feedingType,
        metricType: dropdownMetricValue.value,
        amount: amount,
        duration: duration,
        notes: note);
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
              padding: const EdgeInsets.all(14),
              child: const Text("okay"),
            ),
          ),
        ],
      ),
    );

    await _service.createFoodMetric(model);
    Navigator.pop(context);
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

  final TimeWrapper timeWrapper;

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
              style: TextStyle(color: Colors.white),
            ),
            TextButton(
              child: Text(
                widget.timeWrapper.value.format(context),
              ),
              onPressed: () async {
                TimeOfDay? newTime = await showTimePicker(
                    context: context, initialTime: widget.timeWrapper.value);

                if (newTime == null) return;

                setState(() {
                  widget.timeWrapper.value = newTime;
                  /*
                    Representing some change.
                    I forgot to make this other change. And i want it on the same commit i just did.
                  */
                });
              },
            ),
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

  const NursingView({required this.note, super.key});

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
