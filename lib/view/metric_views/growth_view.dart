import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babytracks/model/GrowthViewModel.dart';

class GrowthView extends StatefulWidget {
  const GrowthView({super.key});

  @override
  State<GrowthView> createState() => _GrowthViewState();
}

class _GrowthViewState extends State<GrowthView> {
   final myController = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();
  final myController4 = TextEditingController();

  TimeOfDay time = TimeOfDay.now();

  DateTime date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);



  String headCircumference = " ";

  String height = " ";

  String weight = " ";

  String note = "";

  final FirebaseAuth auth = FirebaseAuth.instance;

void inputData() {
  final User? user = auth.currentUser;
  final uid = user?.uid;
  String ID = uid.toString(); 
  DateTime when = DateTime(date.year, date.month, date.day, time.hour, time.minute);

  GrowthMetricModel model = GrowthMetricModel(Baby_ID: ID, note: note, headCircumference: headCircumference, height: height, weight: weight, when: when);
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
                const Text('Start Time'),
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
                const Text('Status'),
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
                const Text('Enter Head Circumference (inches) '),
                Flexible(
                child: TextField(
                controller: myController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (String value) {
                  setState(() {
                    headCircumference = value;
                  });
                },
                autofocus: true,
                ),
                ),
              ],
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Enter weight (lbs) '),
                Flexible(
                child: TextField(
                controller: myController3,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (String value) {
                  setState(() {
                    weight = value;
                  });
                },
                autofocus: true,
                ),
                ),
              ],
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Enter height (inches) '),
                Flexible(
                child: TextField(
                controller: myController4,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (String value) {
                  setState(() {
                    height = value;
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

 Future createInstance({required GrowthMetricModel model}) async
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
  final docInstance = FirebaseFirestore.instance.collection('Growth').doc();


  await docInstance.set(model.toJson());

  
 }
}