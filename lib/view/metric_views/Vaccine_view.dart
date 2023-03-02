import 'package:baby_tracks/component/text_divider.dart';
import 'package:baby_tracks/constants/palette.dart';
import 'package:baby_tracks/model/AppUser.dart';
import 'package:baby_tracks/model/VaccineMetricModel.dart';
import 'package:baby_tracks/service/auth.dart';
import 'package:baby_tracks/service/database.dart';
import 'package:flutter/material.dart';

import '../../component/decimal_number_input.dart';

class VaccineView extends StatefulWidget {
  const VaccineView({super.key});

  @override
  State<VaccineView> createState() => _VaccineViewState();
}

class _VaccineViewState extends State<VaccineView> {
  TimeOfDay time = TimeOfDay.now();
  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  
  

  String notes = "";
  String Name = "";
  String babyId = "";
  String series = "";

  late final TextEditingController _note;
  late final ScrollController _noteScroller;

  late final AuthService _auth;
  late final DatabaseService _service;
  late final TextEditingController _vaccine;
  late final TextEditingController _series;

  @override
  void initState() {
    _note = TextEditingController();
    _noteScroller = ScrollController();
    _auth = AuthService();
    _service = DatabaseService();
    _vaccine = TextEditingController();
    _series = TextEditingController();
    

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
    _series.dispose();
    super.dispose();
  }

  Future createInstance() async {
    notes = _note.text;
    series = _series.text;
    

    DateTime when =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);

    VaccineMetricModel model = VaccineMetricModel(
        babyId: babyId,
        timeCreated: when,
        startTime: when,
        Vaccine: Name,
        series: series,
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

    await _service.updateVaccineMetric(model);
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
                  const Text('Select Time'),
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
              const TextDivider(text: 'vaccine name'),
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
                    controller: _vaccine,
                     onChanged: (String value) {
                      setState(() {
                      
                        Name = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter vaccine name',
                      contentPadding: EdgeInsets.all(8),
                    ),
                  ),
                ),
              ),
              
                        
              const TextDivider(text: 'Enter Series'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DecimalInput(controller: _series),
                   
                
              ]
                 
                 
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
