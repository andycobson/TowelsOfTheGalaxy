import 'package:baby_tracks/component/text_divider.dart';
import 'package:baby_tracks/constants/palette.dart';
import 'package:baby_tracks/model/AppUser.dart';
import 'package:baby_tracks/model/ThrowUpMetricModel.dart';
import 'package:baby_tracks/service/auth.dart';
import 'package:baby_tracks/service/database.dart';
import 'package:flutter/material.dart';

class ThrowUpView extends StatefulWidget {
  const ThrowUpView({super.key});

  @override
  State<ThrowUpView> createState() => _ThrowUpViewState();
}

class _ThrowUpViewState extends State<ThrowUpView> {
  TimeOfDay time = TimeOfDay.now();
  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  String notes = "";
  String amount = "";
  String throwUpColor = "";
  String babyId = "";
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

  late final AuthService _auth;
  late final DatabaseService _service;

  @override
  void initState() {
    _note = TextEditingController();
    _color = TextEditingController();
    _noteScroller = ScrollController();
    _amount = TextEditingController();
    _auth = AuthService();
    _service = DatabaseService();
    _colorScroller = ScrollController();

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
    _amount.dispose();
    _colorScroller.dispose();
    _color.dispose();
    super.dispose();
  }

  Future createInstance() async {
    notes = _note.text;
    amount = dropdownAmountValue;

    DateTime when =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    ThrowUpMetricModel model = ThrowUpMetricModel(
        babyId: babyId,
        timeCreated: when,
        startTime: when,
        throwUpColor: throwUpColor,
        amount: amount,
        notes: notes);
    // showDialog(
    //   context: context,
    //   builder: (ctx) => AlertDialog(
    //     title: const Text("Alert"),
    //     content: const Text("Data submitted!"),
    //     actions: <Widget>[
    //       TextButton(
    //         onPressed: () {
    //           Navigator.of(ctx).pop();
    //         },
    //         child: Container(
    //           color: Colors.green,
    //           padding: const EdgeInsets.all(14),
    //           child: const Text("okay"),
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    await _service.createThrowUpMetric(model);
    Navigator.pop(context);
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

              const TextDivider(text: 'Color'),
              SizedBox(
                height: 100,
                child: Scrollbar(
                  controller: _colorScroller,
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    scrollController: _colorScroller,
                    autofocus: false,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _color,
                    onChanged: (String value) {
                      setState(() {
                        throwUpColor = value;
                      });
                    },
                    decoration: const InputDecoration(
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
                    onChanged: (String value) {
                      setState(() {
                        notes = value;
                      });
                    },
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
