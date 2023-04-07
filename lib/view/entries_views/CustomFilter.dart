import 'dart:developer';

import 'package:baby_tracks/component/text_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/palette.dart';

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
                  Container(
                    width: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 0.80),
                    ),
                    child: Center(
                      child: DropdownButton<String>(
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
                    ),
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
                      SizedBox(
                        height: 50,
                        width: 425,
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
                            log("Todo: Create delete method");
                          },
                          child: const Text('Delete'),
                        ),
                      ), //
                      const TextDivider(text: '')
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
                      SizedBox(
                        height: 50,
                        width: 425,
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
                            log("Todo: Create delete method");
                          },
                          child: const Text('Delete'),
                        ),
                      ), //
                      const TextDivider(text: '')
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
                      SizedBox(
                        height: 50,
                        width: 425,
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
                            log("Todo: Create delete method");
                          },
                          child: const Text('Delete'),
                        ),
                      ), //
                      const TextDivider(text: '')
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
                      SizedBox(
                        height: 50,
                        width: 425,
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
                            log("Todo: Create delete method");
                          },
                          child: const Text('Delete'),
                        ),
                      ), //
                      const TextDivider(text: '')
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
                      SizedBox(
                        height: 50,
                        width: 425,
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
                            log("Todo: Create delete method");
                          },
                          child: const Text('Delete'),
                        ),
                      ), //
                      const TextDivider(text: '')
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
                      SizedBox(
                        height: 50,
                        width: 425,
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
                            log("Todo: Create delete method");
                          },
                          child: const Text('Delete'),
                        ),
                      ), //
                      const TextDivider(text: '')
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
                      SizedBox(
                        height: 50,
                        width: 425,
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
                            log("Todo: Create delete method");
                          },
                          child: const Text('Delete'),
                        ),
                      ), //
                      const TextDivider(text: '')
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
