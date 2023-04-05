import 'dart:developer';

import 'package:baby_tracks/component/text_divider.dart';
import 'package:baby_tracks/constants/palette.dart';
import 'package:baby_tracks/model/AppUser.dart';
import 'package:baby_tracks/model/ThrowUpMetricModel.dart';
import 'package:baby_tracks/service/auth.dart';
import 'package:baby_tracks/service/database.dart';
import 'package:flutter/material.dart';

class ThrowUpView extends StatefulWidget {
String id = "";
  

   ThrowUpView(String arg)
   {
    id = arg;
   
   }
  
  

  @override
  State<ThrowUpView> createState() => _ThrowUpViewState(id);
}

class _ThrowUpViewState extends State<ThrowUpView> {
  String id = "";
  int isUpdate = 0;
  TimeOfDay time = TimeOfDay.now();
  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  

  String notes = "";
  String Amount = "";
  String ThrowUpColor = "";
  String babyId = "";
  static const List<String> AmountList = <String>[
    'A lot',
    'Slightly above normal',
    'Normal amount',
    'Slightly below normal',
    'A little'
  ];

   String dropdownAmountValue = AmountList.first;

  late final TextEditingController _note;
  late final TextEditingController _color;
   late final TextEditingController _Amount;
  late final ScrollController _noteScroller;

  late final AuthService _auth;
  late final DatabaseService _service;

    _ThrowUpViewState( String arg ){
   if ( arg == "")
   {
      log("create");
   }
   else
   {
    id = arg;
    isUpdate = 1;
  
    
   }
  }

  @override
  void initState() {
    _note = TextEditingController();
    _color = TextEditingController();
    _noteScroller = ScrollController();
    _Amount = TextEditingController();
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
    _Amount.dispose();
    super.dispose();
  }

  Future createInstance() async {
    notes = _note.text;
    Amount = dropdownAmountValue;
    

    DateTime when =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    ThrowUpMetricModel model = ThrowUpMetricModel(
        babyId: babyId,
        timeCreated: when,
        startTime: when,
        ThrowUpColor: ThrowUpColor,
        Amount: Amount,
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

    if (isUpdate == 0)  
    {
      await _service.updateThrowUpMetric(model);
    }
    else
    {
      log("should Edit");
      await _service.editThrowUpMetric(model, id);
      
    }
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
                  const Text('Start Time'),
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
                  controller: _noteScroller,
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    scrollController: _noteScroller,
                    autofocus: false,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller: _color,
                     onChanged: (String value) {
                      setState(() {
                      
                        ThrowUpColor = value;
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
                  DropdownButton<String>(
                    value: dropdownAmountValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: ColorPalette.background),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownAmountValue = value!;
                      });
                    },
                    items: AmountList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
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
