import 'package:baby_tracks/component/text_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/palette.dart';
import '../../model/MetricInterface.dart';
import '../../model/persistentUser.dart';
import '../../service/database.dart';
import '../../wrapperClasses/pair.dart';

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
                    decoration: const BoxDecoration(color: Colors.white),
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
                ],
              ),
              const TextDivider(text: 'Select Start Date'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Date',
                    style: TextStyle(
                      color: ColorPalette.pText,
                    ),
                  ),
                  TextButton(
                    child: Text("${dateA.month}/${dateA.day}/${dateA.year}"),
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
                  const Text(
                    'Date',
                    style: TextStyle(
                      color: ColorPalette.pText,
                    ),
                  ),
                  TextButton(
                    child: Text("${dateB.month}/${dateB.day}/${dateB.year}"),
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
                            endDate: dateB.add(const Duration(days: 1))),
                      ),
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
  DateTime defualtStartDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime defualtEndDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  SearchRoute(
      {super.key,
      required String sentPhrase,
      required startDate,
      required endDate}) {
    display = sentPhrase;
    defualtStartDate = startDate;
    defualtEndDate = endDate;
  }

  final DatabaseService _service = DatabaseService();

  String babyName = PersistentUser.instance.currentBabyName;
  String userId = PersistentUser.instance.userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: ColorPalette.backgroundRGB,
        elevation: 0,
      ),
      backgroundColor: ColorPalette.backgroundRGB,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                StreamBuilder(
                  stream: _service
                      .timeQuery(defualtStartDate, defualtEndDate, display,
                          "$userId#$babyName")
                      .asStream(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Pair>> snapshots) {
                    if (!snapshots.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: snapshots.data!.map((pairs) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 25.0, horizontal: 40.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              (pairs.right as MetricInterface)
                                  .analyticsWidget(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 50,
                                    width: 100,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  ColorPalette.redDelete),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ))),
                                      onPressed: () async {
                                        final docUser = FirebaseFirestore
                                            .instance
                                            .collection(
                                                (pairs.right as MetricInterface)
                                                    .getCollectionName())
                                            .doc(pairs.left);
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
                                            MaterialStateProperty.all(
                                                ColorPalette.defaultBlue),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        await (pairs.right as MetricInterface)
                                            .routeToEdit(context, pairs.left);
                                      },
                                      child: const Text('Edit'),
                                    ),
                                  ), //
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
