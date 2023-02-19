import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:babytracks/model/FoodViewModel.dart';

class FoodView extends StatefulWidget {
  const FoodView({super.key});

  @override
  State<FoodView> createState() => _FoodViewState();
}

class _FoodViewState extends State<FoodView> {
   final myController = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();
  final myController4 = TextEditingController();

  TimeOfDay time = TimeOfDay.now();

  DateTime date = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);



  String feedingType = " ";

  String Amt = " ";

  String duration = " ";

  String note = "";

  final FirebaseAuth auth = FirebaseAuth.instance;

void inputData() {
  final User? user = auth.currentUser;
  final uid = user?.uid;
  String ID = uid.toString(); 
  DateTime when = DateTime(date.year, date.month, date.day, time.hour, time.minute);

  FoodMetricModel model = FoodMetricModel(Baby_ID: ID, note: note, feedingType: feedingType, Amt: Amt, duration: duration, when: when);
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
                const Text('Enter feeding type (Nursing, Feeding, or both): '),
                Flexible(
                child: TextField(
                controller: myController,
                onChanged: (String value) {
                  setState(() {
                    feedingType = value;
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
                const Text('Enter nursing duration in min (0 if NA)'),
                Flexible(
                child: TextField(
                controller: myController3,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (String value) {
                  setState(() {
                    duration = value;
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
                const Text('Enter feeding amount in g (0 if NA)'),
                Flexible(
                child: TextField(
                controller: myController4,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (String value) {
                  setState(() {
                    Amt = value;
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

 Future createInstance({required FoodMetricModel model}) async
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
  final docInstance = FirebaseFirestore.instance.collection('Food').doc();

  /** 
  final json = {
    'Baby_ID': Baby_ID,
    'note': note,
    'FType': feedingType,
    'FeedingAmt': double.parse('0'+Amt),
    'Nursingduration': double.parse('0'+duration),
    'TimeCreated': when
  }; */
  await docInstance.set(model.toJson());

  
 }
}