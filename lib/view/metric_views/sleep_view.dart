import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babytracks/model/SleepViewModel.dart';

class SleepView extends StatefulWidget {
  const SleepView({super.key});

  @override
  State<SleepView> createState() => _SleepViewState();
}

class _SleepViewState extends State<SleepView> {
   final myController = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();
  final myController4 = TextEditingController();

  TimeOfDay time = TimeOfDay.now();

  DateTime date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);



  TimeOfDay starttime = TimeOfDay.now();

  DateTime startdate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

   TimeOfDay endtime = TimeOfDay.now();

  DateTime enddate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);


  String note = "";

  final FirebaseAuth auth = FirebaseAuth.instance;

void inputData() {
  final User? user = auth.currentUser;
  final uid = user?.uid;
  String ID = uid.toString(); 
  DateTime when = DateTime(date.year, date.month, date.day, time.hour, time.minute);
  DateTime start = DateTime(startdate.year, startdate.month, startdate.day,starttime.hour, starttime.minute);
   DateTime end = DateTime(enddate.year,enddate.month, enddate.day,endtime.hour, endtime.minute);
   Duration duration = end.difference(start);
   String dur = ((duration.inMinutes)/60).toString();

   SleepMetricModel model = SleepMetricModel(Baby_ID: ID, note: note, start: start, end: end, dur: dur, when: when);

  createInstance(model: model);
  
               
  // log uid, note, status, date, time
  // write the codes to input the data into firestore
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 50.0),
        child: Column(
          children: [
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text('Time'),
                const Expanded(
                  child: Divider(
                    thickness: 2.0,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Post Time'),
                TextButton(
                  child: Text(time.toString()),
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
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text('Date'),
                const Expanded(
                  child: Divider(
                    thickness: 2.0,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Enter Date'),
                TextButton(
                  child: Text(date.toString()),
                  onPressed: () async {
                    DateTime? newDate = await showDatePicker(context: context, initialDate: date, firstDate:DateTime(2015, 8), lastDate: date);

                    if (newDate == null) return;

                    setState(() {
                      date = newDate;
                    });
                  },
                ),
              ],
            ),
             Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text('Time'),
                const Expanded(
                  child: Divider(
                    thickness: 2.0,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('End Time'),
                TextButton(
                  child: Text(endtime.toString()),
                  onPressed: () async {
                    TimeOfDay? newTime2 = await showTimePicker(
                        context: context, initialTime: endtime);

                    if (newTime2 == null) return;

                    setState(() {
                      endtime = newTime2;
                    });
                  },
                ),
              ],
            ),
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text('Date'),
                const Expanded(
                  child: Divider(
                    thickness: 2.0,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Enter end Date'),
                TextButton(
                  child: Text(enddate.toString()),
                  onPressed: () async {
                    DateTime? newDate2 = await showDatePicker(context: context, initialDate: date, firstDate:DateTime(2015, 8), lastDate: date);

                    if (newDate2 == null) return;

                    setState(() {
                      enddate = newDate2;
                    });
                  },
                ),
              ],
            ),
             Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text('Time'),
                const Expanded(
                  child: Divider(
                    thickness: 2.0,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Start Time'),
                TextButton(
                  child: Text(starttime.toString()),
                  onPressed: () async {
                    TimeOfDay? newTime3 = await showTimePicker(
                        context: context, initialTime: starttime);

                    if (newTime3 == null) return;

                    setState(() {
                      starttime = newTime3;
                    });
                  },
                ),
              ],
            ),
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text('Date'),
                const Expanded(
                  child: Divider(
                    thickness: 2.0,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Enter start Date'),
                TextButton(
                  child: Text(startdate.toString()),
                  onPressed: () async {
                    DateTime? newDate3 = await showDatePicker(context: context, initialDate: date, firstDate:DateTime(2015, 8), lastDate: date);

                    if (newDate3 == null) return;

                    setState(() {
                      startdate = newDate3;
                    });
                  },
                ),
              ],
            ),
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Text('Note'),
                const Expanded(
                  child: Divider(
                    thickness: 2.0,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Enter Note:  '),
                Flexible(
                  child: TextField(
                    controller: myController2,
                    onChanged: (String value) {
                      setState(() {
                        note = value;
                      });
                    },
                    autofocus: true,
                  ),
                ),
              ],
            ),
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                MaterialButton(
                minWidth: 200.0,
                height: 35,
                color: Color(0xFF801E48),
                child: new Text('Enter Data'),
                onPressed: () {
                  inputData();
                  setState(() {

                  });
                }
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

 Future createInstance({required SleepMetricModel model}) async
 {

   showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Alert"),
                  content:  Text("Data submitted!" ) ,
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
  final docInstance = FirebaseFirestore.instance.collection('Sleep').doc();
  
  await docInstance.set(model.toJson());

  
 }
  
}