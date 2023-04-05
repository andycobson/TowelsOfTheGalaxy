import 'dart:developer';

import 'package:baby_tracks/component/text_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/palette.dart';
import '../metric_views/Vaccine_view.dart';
import '../metric_views/diaper_view.dart';
import '../metric_views/food_view.dart';
import '../metric_views/growth_view.dart';
import '../metric_views/sleep_view.dart';
import '../metric_views/temperature_view.dart';
import '../metric_views/throwup_view.dart';

class CustomView extends StatefulWidget {
  const CustomView({super.key});

  @override
  State<CustomView> createState() => _CustomViewState();
}

class _CustomViewState extends State<CustomView> {
  static const List<String> feedingTypeList = <String>[
    'Diaper',
    'Food',
    'Growth',
    'Sleep',
    'Temperature',
    'Throwup',
    'Vaccine',
  ];
  String dropdownFoodValue = feedingTypeList.first;
  String phrase = "passed";
  DateTime dateA =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime dateB =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter'),
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
              const TextDivider(text: 'Select Category'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton<String>(
                    value: dropdownFoodValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: ColorPalette.background),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownFoodValue = value!;
                      });
                    },
                    items: feedingTypeList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const TextDivider(text: 'Select Start Date'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Date'),
                  TextButton(
                    child: Text(dateA.month.toString() +
                        "/" +
                        dateA.day.toString() +
                        "/" +
                        dateA.year.toString()),
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: dateA,
                          firstDate: DateTime(2016),
                          lastDate: DateTime(2101));

                      if (newDate == null) return;

                      setState(() {
                        dateA = newDate;
                      });
                    },
                  ),
                ],
              ),
              const TextDivider(text: 'Select End Date'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Date'),
                  TextButton(
                    child: Text(dateB.month.toString() +
                        "/" +
                        dateB.day.toString() +
                        "/" +
                        dateB.year.toString()),
                    onPressed: () async {
                      DateTime? newDate = await showDatePicker(
                          context: context,
                          initialDate: dateB,
                          firstDate: DateTime(2016),
                          lastDate: DateTime(2101));

                      if (newDate == null) return;

                      setState(() {
                        dateB = newDate;
                      });
                    },
                  ),
                ],
              ),
              Center(
                child: ElevatedButton(
                  child: const Text('Search'),
                  onPressed: () {
                    phrase = dropdownFoodValue;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchRoute(
                              sentPhrase: phrase,
                              startDate: dateA,
                              endDate: dateB)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchRoute extends StatelessWidget {
  String display = "failed";
  DateTime start_Date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime end_Date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  SearchRoute(
      {required String sentPhrase, required startDate, required endDate}) {
    display = sentPhrase;
    start_Date = startDate;
    end_Date = endDate;
  }

  Widget build(BuildContext context) {
    if (display == "Diaper") {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          backgroundColor: ColorPalette.backgroundRGB,
          elevation: 0,
        ),
        backgroundColor: Color.fromARGB(255, 67, 67, 209),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Diaper')
              .where('timeCreated', isGreaterThanOrEqualTo: start_Date)
              .where('timeCreated', isLessThanOrEqualTo: end_Date)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 25.0, horizontal: 40.0),
                    child: Column(children: [
                      const TextDivider(text: 'New Entry'),
                      const TextDivider(text: 'Occured at:'),
                      Center(
                          child: Text(
                              doc.data().toString().contains('timeCreated')
                                  ? doc.get('timeCreated').toDate().toString()
                                  : (2016).toString())),
                      const TextDivider(text: 'Status'),
                      Center(
                          child: Text(
                              doc.data().toString().contains('diaperContents')
                                  ? doc.get('diaperContents')
                                  : '')),
                      const TextDivider(text: 'Notes'),
                      Center(
                          child: Text(doc.data().toString().contains('notes')
                              ? doc.get('notes')
                              : '')),
                      Row(
                        children: [const Text("")],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () async {
                                  final docUser = FirebaseFirestore.instance
                                      .collection('Diaper')
                                      .doc(doc.id);
                                  docUser.delete();
                                },
                                child: const Text('Delete'),
                              ),
                            ), //

                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () async {
                                  log('Todo: update method');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DiaperView(doc.id)));
                                },
                                child: const Text('Edit'),
                              ),
                            ), //
                          ])
                    ]));
              }).toList(),
            );
          },
        ),
      );
    } else if (display == "Food") {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          backgroundColor: ColorPalette.backgroundRGB,
          elevation: 0,
        ),
        backgroundColor: Color.fromARGB(255, 67, 67, 209),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Food')
              .where('timeCreated', isGreaterThanOrEqualTo: start_Date)
              .where('timeCreated', isLessThanOrEqualTo: end_Date)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 25.0, horizontal: 40.0),
                    child: Column(children: [
                      const TextDivider(text: 'New Entry'),
                      const TextDivider(text: 'Occured at:'),
                      Center(
                          child: Text(
                              doc.data().toString().contains('timeCreated')
                                  ? doc.get('timeCreated').toDate().toString()
                                  : (2016).toString())),
                      const TextDivider(text: 'Nursing, Feeding, or Both?'),
                      Center(
                          child: Text(
                              doc.data().toString().contains('feedingType')
                                  ? doc.get('feedingType')
                                  : '')),
                      const TextDivider(text: 'Feeding Amount'),
                      Center(
                          child: Text((doc.data().toString().contains('amount')
                                  ? doc.get('amount').toString()
                                  : 0.toString()) +
                              (doc.data().toString().contains('metricType')
                                  ? doc.get('metricType')
                                  : ''))),
                      const TextDivider(text: 'Times of Nursing'),
                      Center(
                          child: Text(
                              (doc.data().toString().contains('startTime')
                                      ? doc.get('startTime').toDate().toString()
                                      : (2016).toString()) +
                                  ' to ' +
                                  (doc.data().toString().contains('endTime')
                                      ? doc.get('endTime').toDate().toString()
                                      : (2016).toString()))),
                      const TextDivider(text: 'Nursing Duration'),
                      Center(
                          child: Text(
                              (doc.data().toString().contains('duration')
                                      ? doc.get('duration').toString()
                                      : 0.toString()) +
                                  (" Minutes"))),
                      const TextDivider(text: 'Notes'),
                      Center(
                          child: Text(doc.data().toString().contains('notes')
                              ? doc.get('notes')
                              : '')),
                      Row(
                        children: [const Text("")],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () async {
                                  final docUser = FirebaseFirestore.instance
                                      .collection('Food')
                                      .doc(doc.id);
                                  docUser.delete();
                                },
                                child: const Text('Delete'),
                              ),
                            ),

                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () async {
                                  log('Todo: update method');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FoodView(doc.id)));
                                },
                                child: const Text('Edit'),
                              ),
                            ), //
                          ])
                    ]));
              }).toList(),
            );
          },
        ),
      );
    } else if (display == "Growth") {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          backgroundColor: ColorPalette.backgroundRGB,
          elevation: 0,
        ),
        backgroundColor: Color.fromARGB(255, 67, 67, 209),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Growth')
              .where('timeCreated', isGreaterThanOrEqualTo: start_Date)
              .where('timeCreated', isLessThanOrEqualTo: end_Date)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 25.0, horizontal: 40.0),
                    child: Column(children: [
                      const TextDivider(text: 'New Entry'),
                      const TextDivider(text: 'Occured at:'),
                      Center(
                          child: Text(
                              doc.data().toString().contains('timeCreated')
                                  ? doc.get('timeCreated').toDate().toString()
                                  : (2016).toString())),
                      const TextDivider(text: 'Head Circumference'),
                      Center(
                          child: Text((doc
                                      .data()
                                      .toString()
                                      .contains('headCircumference')
                                  ? doc.get('headCircumference').toString()
                                  : 0.toString()) +
                              (" inches"))),
                      const TextDivider(text: 'Head Circumference'),
                      Center(
                          child: Text((doc
                                      .data()
                                      .toString()
                                      .contains('headCircumference')
                                  ? doc.get('headCircumference').toString()
                                  : 0.toString()) +
                              (" inches"))),
                      const TextDivider(text: 'Height'),
                      Center(
                          child: Text((doc.data().toString().contains('height')
                                  ? doc.get('height').toString()
                                  : 0.toString()) +
                              (" Inches"))),
                      const TextDivider(text: 'Weight'),
                      Center(
                          child: Text((doc.data().toString().contains('weight')
                                  ? doc.get('weight').toString()
                                  : 0.toString()) +
                              (" Pounds"))),
                      const TextDivider(text: 'Notes'),
                      Center(
                          child: Text(doc.data().toString().contains('notes')
                              ? doc.get('notes')
                              : '')),
                      Row(
                        children: [const Text("")],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () async {
                                  final docUser = FirebaseFirestore.instance
                                      .collection('Growth')
                                      .doc(doc.id);
                                  docUser.delete();
                                },
                                child: const Text('Delete'),
                              ),
                            ), //

                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () async {
                                  log('Todo: update method');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GrowthView(doc.id)));
                                },
                                child: const Text('Edit'),
                              ),
                            ), //
                          ])
                    ]));
              }).toList(),
            );
          },
        ),
      );
    } else if (display == "Sleep") {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          backgroundColor: ColorPalette.backgroundRGB,
          elevation: 0,
        ),
        backgroundColor: Color.fromARGB(255, 67, 67, 209),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Sleep')
              .where('timeCreated', isGreaterThanOrEqualTo: start_Date)
              .where('timeCreated', isLessThanOrEqualTo: end_Date)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 25.0, horizontal: 40.0),
                    child: Column(children: [
                      const TextDivider(text: 'New Entry'),
                      const TextDivider(text: 'Entry posted at:'),
                      Center(
                          child: Text(
                              doc.data().toString().contains('timeCreated')
                                  ? doc.get('timeCreated').toDate().toString()
                                  : (2016).toString())),
                      const TextDivider(text: 'Times frame of nap'),
                      Center(
                          child: Text(
                              (doc.data().toString().contains('startTime')
                                      ? doc.get('startTime').toDate().toString()
                                      : (2016).toString()) +
                                  ' to ' +
                                  (doc.data().toString().contains('endTime')
                                      ? doc.get('endTime').toDate().toString()
                                      : (2016).toString()))),
                      const TextDivider(text: 'Duration'),
                      Center(
                          child: Text(
                              (doc.data().toString().contains('duration')
                                      ? doc.get('duration').toString()
                                      : 0.toString()) +
                                  (" Hours"))),
                      const TextDivider(text: 'Notes'),
                      Center(
                          child: Text(doc.data().toString().contains('notes')
                              ? doc.get('notes')
                              : '')),
                      Row(
                        children: [const Text("")],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () async {
                                  final docUser = FirebaseFirestore.instance
                                      .collection('Sleep')
                                      .doc(doc.id);
                                  docUser.delete();
                                },
                                child: const Text('Delete'),
                              ),
                            ),

                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () async {
                                  log('Todo: update method');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SleepView(doc.id)));
                                },
                                child: const Text('Edit'),
                              ),
                            ), // //
                          ])
                    ]));
              }).toList(),
            );
          },
        ),
      );
    } else if (display == "Temperature") {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          backgroundColor: ColorPalette.backgroundRGB,
          elevation: 0,
        ),
        backgroundColor: Color.fromARGB(255, 67, 67, 209),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Temperature')
              .where('timeCreated', isGreaterThanOrEqualTo: start_Date)
              .where('timeCreated', isLessThanOrEqualTo: end_Date)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 25.0, horizontal: 40.0),
                    child: Column(children: [
                      const TextDivider(text: 'New Entry'),
                      const TextDivider(text: 'Entry posted at:'),
                      Center(
                          child: Text(
                              doc.data().toString().contains('timeCreated')
                                  ? doc.get('timeCreated').toDate().toString()
                                  : (2016).toString())),
                      const TextDivider(text: 'Temperature'),
                      Center(
                          child: Text(
                              (doc.data().toString().contains('temperature')
                                      ? doc.get('temperature').toString()
                                      : 0.toString()) +
                                  ' ° ' +
                                  (doc.data().toString().contains('tempType')
                                      ? doc.get('tempType')
                                      : ''))),
                      const TextDivider(text: 'Taken at:'),
                      Center(
                          child: Text(doc.data().toString().contains('TempTime')
                              ? doc.get('TempTime').toDate().toString()
                              : (2016).toString())),
                      const TextDivider(text: 'Notes'),
                      Center(
                          child: Text(doc.data().toString().contains('notes')
                              ? doc.get('notes')
                              : '')),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () async {
                                  final docUser = FirebaseFirestore.instance
                                      .collection('Temperature')
                                      .doc(doc.id);
                                  docUser.delete();
                                },
                                child: const Text('Delete'),
                              ),
                            ),
                            Row(
                              children: [const Text("")],
                            ),
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () async {
                                  log('Todo: update method');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TemperatureView(doc.id)));
                                },
                                child: const Text('Edit'),
                              ),
                            ), // //
                          ])
                    ]));
              }).toList(),
            );
          },
        ),
      );
    } else if (display == "Throwup") {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          backgroundColor: ColorPalette.backgroundRGB,
          elevation: 0,
        ),
        backgroundColor: Color.fromARGB(255, 67, 67, 209),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Throwup')
              .where('timeCreated', isGreaterThanOrEqualTo: start_Date)
              .where('timeCreated', isLessThanOrEqualTo: end_Date)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 25.0, horizontal: 40.0),
                    child: Column(children: [
                      const TextDivider(text: 'New Entry'),
                      const TextDivider(text: 'Entry Created at:'),
                      Center(
                          child: Text(
                              doc.data().toString().contains('timeCreated')
                                  ? doc.get('timeCreated').toDate().toString()
                                  : (2016).toString())),
                      const TextDivider(text: 'Color'),
                      Center(
                          child: Text(
                              doc.data().toString().contains('ThrowUpColor')
                                  ? doc.get('ThrowUpColor')
                                  : '')),
                      const TextDivider(text: 'Amount'),
                      Center(
                          child: Text(doc.data().toString().contains('amount')
                              ? doc.get('amount')
                              : '')),
                      const TextDivider(text: 'Taken at:'),
                      Center(
                          child: Text(
                              doc.data().toString().contains('startTime')
                                  ? doc.get('startTime').toDate().toString()
                                  : (2016).toString())),
                      const TextDivider(text: 'Notes'),
                      Center(
                          child: Text(doc.data().toString().contains('notes')
                              ? doc.get('notes')
                              : '')),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () async {
                                  final docUser = FirebaseFirestore.instance
                                      .collection('Throwup')
                                      .doc(doc.id);
                                  docUser.delete();
                                },
                                child: const Text('Delete'),
                              ),
                            ),
                            Row(
                              children: [const Text("")],
                            ),
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () async {
                                  log('Todo: update method');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ThrowUpView(doc.id)));
                                },
                                child: const Text('Edit'),
                              ),
                            ), ////
                          ])
                    ]));
              }).toList(),
            );
          },
        ),
      );
    } else if (display == "Vaccine") {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          backgroundColor: ColorPalette.backgroundRGB,
          elevation: 0,
        ),
        backgroundColor: Color.fromARGB(255, 67, 67, 209),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Vaccine')
              .where('timeCreated', isGreaterThanOrEqualTo: start_Date)
              .where('timeCreated', isLessThanOrEqualTo: end_Date)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 25.0, horizontal: 40.0),
                    child: Column(children: [
                      const TextDivider(text: 'New Entry'),
                      const TextDivider(text: 'Entry Created at:'),
                      Center(
                          child: Text(
                              doc.data().toString().contains('timeCreated')
                                  ? doc.get('timeCreated').toDate().toString()
                                  : (2016).toString())),
                      const TextDivider(text: 'Vaccine'),
                      Center(
                          child: Text((doc.data().toString().contains('Vaccine')
                                  ? doc.get('Vaccine')
                                  : '') +
                              " Series: " +
                              (doc.data().toString().contains('series')
                                  ? doc.get('series').toString()
                                  : 0.toString()))),
                      const TextDivider(text: 'Taken at:'),
                      Center(
                          child: Text(
                              doc.data().toString().contains('startTime')
                                  ? doc.get('startTime').toDate().toString()
                                  : (2016).toString())),
                      const TextDivider(text: 'Notes'),
                      Center(
                          child: Text(doc.data().toString().contains('notes')
                              ? doc.get('notes')
                              : '')),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () async {
                                  final docUser = FirebaseFirestore.instance
                                      .collection('Vaccine')
                                      .doc(doc.id);
                                  docUser.delete();
                                },
                                child: const Text('Delete'),
                              ),
                            ),

                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.red),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                onPressed: () async {
                                  log('Todo: update method');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VaccineView(doc.id)));
                                },
                                child: const Text('Edit'),
                              ),
                            ), // //
                          ])
                    ]));
              }).toList(),
            );
          },
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          backgroundColor: ColorPalette.backgroundRGB,
          elevation: 0,
        ),
        backgroundColor: Color.fromARGB(255, 67, 67, 209),
      );
    }
  }
}
