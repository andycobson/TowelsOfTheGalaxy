import 'package:baby_tracks/component/text_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants/palette.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({super.key});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> {
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
              const TextDivider(text: 'Select Start Date'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('Date'),
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
                  const Text('Date'),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SearchRoute(startDate: dateA, endDate: dateB)),
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
  DateTime start_Date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime end_Date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  int DiaperEntrys = 0;
  int FoodEntrys = 0;
  int VomitEntrys = 0;
  int GrowthEntrys = 0;
  int SleepEntrys = 0;
  int VaccineEntrys = 0;
  int TempEntrys = 0;
  int x = 1;

  int AmtofDays = 0;
  int AmtofDaysGrowth = 0;

  double TotSleep = 0;
  double TotFeeding = 0;
  double TotLiquid = 0;
  double TotNursing = 0;
  double TotTemp = 0;
  int sleepRan = 0;
  int feedingRan = 0;
  int tempRan = 0;
  int growthRan = 0;

  double ChangeHeight = 0;
  double ChangeWeight = 0;
  double ChangeHead = 0;

  double feedingAvg = 0;
  double liquidAvg = 0;
  double nursingAvg = 0;
  double tempAvg = 0;
  double sleepAvg = 0;

  double dailyFeed = 0;
  double dailyLiquid = 0;
  double dailyNurse = 0;
  double dailySleep = 0;
  double dailyGrowthHeight = 0;
  double dailyGrowthWeight = 0;
  double dailyGrowthHC = 0;

  SearchRoute({required startDate, required endDate}) {
    start_Date = startDate;
    end_Date = endDate;
    AmtofDays = ((end_Date.difference(start_Date)).inDays) + 1;
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          backgroundColor: ColorPalette.backgroundRGB,
          elevation: 0,
        ),
        backgroundColor: ColorPalette.backgroundRGB,
        body: SingleChildScrollView(
          child: Column(children: [
            Column(children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Diaper')
                      .where('timeCreated', isGreaterThanOrEqualTo: start_Date)
                      .where('timeCreated', isLessThanOrEqualTo: end_Date)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        DiaperEntrys =
                            int.parse((snapshot.data?.docs.length).toString());
                        return const SizedBox(height: 0);

                        //log((DiaperEntrys).toString());
                      },
                    );
                  })
            ]),
            Column(children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Food')
                      .where('timeCreated', isGreaterThanOrEqualTo: start_Date)
                      .where('timeCreated', isLessThanOrEqualTo: end_Date)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        FoodEntrys =
                            int.parse((snapshot.data?.docs.length).toString());
                        if (feedingRan == 0) {
                          for (var i = 0; i < FoodEntrys; i++) {
                            if ((snapshot.data?.docs[i]['metricType'] ==
                                "oz")) {
                              TotFeeding = TotFeeding +
                                  (snapshot.data?.docs[i]['amount']);
                            } else if ((snapshot.data?.docs[i]['metricType'] ==
                                "ml")) {
                              TotLiquid = TotLiquid +
                                  (snapshot.data?.docs[i]['amount']);
                            }

                            TotNursing = TotNursing +
                                (snapshot.data?.docs[i]['duration']);
                          }

                          feedingAvg = TotFeeding / FoodEntrys;
                          liquidAvg = TotLiquid / FoodEntrys;
                          nursingAvg = TotNursing / FoodEntrys;
                          dailyFeed = TotFeeding / AmtofDays;
                          dailyNurse = TotNursing / AmtofDays;
                          dailyLiquid = TotLiquid / AmtofDays;
                          feedingRan = 1;
                        }
                        // //log((FoodEntrys).toString());
                        // //log((TotFeeding).toString());
                        // //log((TotNursing).toString());
                        return const SizedBox(height: 0);
                      },
                    );
                  })
            ]),
            Column(children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Growth')
                      .where('timeCreated', isGreaterThanOrEqualTo: start_Date)
                      .where('timeCreated', isLessThanOrEqualTo: end_Date)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        if (growthRan == 0) {
                          GrowthEntrys = int.parse(
                              (snapshot.data?.docs.length).toString());

                          DateTime earliestDate = DateTime(2030);
                          DateTime latestDate = DateTime(2016);

                          double earliestHeight = 0;
                          double earliestWeight = 0;
                          double earliestHC = 0;

                          double latestHeight = 0;
                          double latestWeight = 0;
                          double latestHC = 0;

                          for (var i = 0; i < GrowthEntrys; i++) {
                            Timestamp TTime =
                                (snapshot.data?.docs[i]['timeCreated']);
                            DateTime TempTime =
                                DateTime.fromMicrosecondsSinceEpoch(
                                    TTime.microsecondsSinceEpoch);
                            if (TempTime.isAfter(latestDate)) {
                              latestDate = TempTime;
                              if ((snapshot.data?.docs[i]['weightType']) ==
                                  'lb') {
                                latestWeight =
                                    (snapshot.data?.docs[i]['weight']);
                              } else if ((snapshot.data?.docs[i]
                                      ['weightType']) ==
                                  'kg') {
                                latestWeight =
                                    ((snapshot.data?.docs[i]['weight']) * 2.2);
                              }
                              if ((snapshot.data?.docs[i]['heightType']) ==
                                  'in') {
                                latestHeight =
                                    (snapshot.data?.docs[i]['height']);
                              } else if ((snapshot.data?.docs[i]
                                      ['heightType']) ==
                                  'cm') {
                                latestHeight =
                                    ((snapshot.data?.docs[i]['height']) / 2.54);
                              }
                              if ((snapshot.data?.docs[i]['HCType']) == 'in') {
                                latestHC = (snapshot.data?.docs[i]
                                    ['headCircumference']);
                              } else if ((snapshot.data?.docs[i]['HCType']) ==
                                  'cm') {
                                latestHC = ((snapshot.data?.docs[i]
                                        ['headCircumference']) /
                                    2.54);
                              }
                              //  latestHeight = (snapshot.data?.docs[i]['height']);
                              //  latestWeight = (snapshot.data?.docs[i]['weight']);
                              //  latestHC = (snapshot.data?.docs[i]['headCircumference']);
                            }

                            if (TempTime.isBefore(earliestDate)) {
                              earliestDate = TempTime;
                              // height conversion
                              if ((snapshot.data?.docs[i]['weightType']) ==
                                  'lb') {
                                earliestWeight =
                                    (snapshot.data?.docs[i]['weight']);
                              } else if ((snapshot.data?.docs[i]
                                      ['weightType']) ==
                                  'kg') {
                                earliestWeight =
                                    ((snapshot.data?.docs[i]['weight']) * 2.2);
                              }
                              if ((snapshot.data?.docs[i]['heightType']) ==
                                  'in') {
                                earliestHeight =
                                    (snapshot.data?.docs[i]['height']);
                              } else if ((snapshot.data?.docs[i]
                                      ['heightType']) ==
                                  'cm') {
                                earliestHeight =
                                    ((snapshot.data?.docs[i]['height']) / 2.54);
                              }
                              if ((snapshot.data?.docs[i]['HCType']) == 'in') {
                                earliestHC = (snapshot.data?.docs[i]
                                    ['headCircumference']);
                              } else if ((snapshot.data?.docs[i]['HCType']) ==
                                  'cm') {
                                earliestHC = ((snapshot.data?.docs[i]
                                        ['headCircumference']) /
                                    2.54);
                              }
                              // earliestHeight = (snapshot.data?.docs[i]['height']);
                              //  earliestWeight = (snapshot.data?.docs[i]['weight']);
                              // earliestHC = (snapshot.data?.docs[i]['headCircumference']);
                            }
                          }
                          ChangeHead = latestHC - earliestHC;
                          ChangeHeight = latestHeight - earliestHeight;
                          ChangeWeight = latestWeight - earliestWeight;
                          AmtofDaysGrowth =
                              ((latestDate.difference(earliestDate)).inDays) +
                                  1;

                          dailyGrowthHeight = ChangeHeight / AmtofDaysGrowth;
                          dailyGrowthWeight = ChangeWeight / AmtofDaysGrowth;
                          dailyGrowthHC = ChangeHead / AmtofDaysGrowth;
                          growthRan = 1;
                        }

                        return const SizedBox(height: 0);
                      },
                    );
                  })
            ]),
            Column(children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Sleep')
                      .where('timeCreated', isGreaterThanOrEqualTo: start_Date)
                      .where('timeCreated', isLessThanOrEqualTo: end_Date)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        if (sleepRan == 0) {
                          SleepEntrys = int.parse(
                              (snapshot.data?.docs.length).toString());

                          for (var i = 0; i < SleepEntrys; i++) {
                            TotSleep =
                                TotSleep + (snapshot.data?.docs[i]['duration']);
                          }

                          sleepAvg = TotSleep / SleepEntrys;
                          dailySleep = TotSleep / AmtofDays;
                          sleepRan = 1;
                        }
                        //log((SleepEntrys).toString());
                        //log((TotSleep).toString());

                        return const SizedBox(height: 0);
                      },
                    );
                  })
            ]),
            Column(children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Temperature')
                      .where('timeCreated', isGreaterThanOrEqualTo: start_Date)
                      .where('timeCreated', isLessThanOrEqualTo: end_Date)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        if (tempRan == 0) {
                          TempEntrys = int.parse(
                              (snapshot.data?.docs.length).toString());
                          for (var i = 0; i < TempEntrys; i++) {
                            if ((snapshot.data?.docs[i]['tempType']) == 'F') {
                              TotTemp = TotTemp +
                                  (snapshot.data?.docs[i]['temperature']);
                            } else if ((snapshot.data?.docs[i]['tempType']) ==
                                'C') {
                              TotTemp = TotTemp +
                                  (((snapshot.data?.docs[i]['temperature']) *
                                          1.8) +
                                      32);
                            }
                          }

                          tempAvg = TotTemp / TempEntrys;
                          tempRan = 1;
                        }
                        //log((TempEntrys).toString());
                        //log(TotTemp.toString());

                        return const SizedBox(height: 0);
                      },
                    );
                  })
            ]),
            Column(children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Throwup')
                      .where('timeCreated', isGreaterThanOrEqualTo: start_Date)
                      .where('timeCreated', isLessThanOrEqualTo: end_Date)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        VomitEntrys =
                            int.parse((snapshot.data?.docs.length).toString());

                        //log((VomitEntrys).toString());

                        return const SizedBox(height: 0);
                      },
                    );
                  })
            ]),
            Column(children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Vaccine')
                      .where('timeCreated', isGreaterThanOrEqualTo: start_Date)
                      .where('timeCreated', isLessThanOrEqualTo: end_Date)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        VaccineEntrys =
                            int.parse((snapshot.data?.docs.length).toString());

                        return const SizedBox(height: 0);
                      },
                    );
                  }),
            ]),
            Column(children: [
              StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection('Baby').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        if (x == 1) {
                          x = x + 1;
                          return Column(children: [
                            const TextDivider(text: "Amount of Entries"),
                            Row(children: [
                              const Text(
                                "Diaper entries:",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                (DiaperEntrys).toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              )
                            ]),
                            Row(children: [
                              const Text(
                                "Feeding entries:",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                (FoodEntrys).toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              )
                            ]),
                            Row(children: [
                              const Text(
                                "Growth entries:",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                (GrowthEntrys).toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              )
                            ]),
                            Row(children: [
                              const Text(
                                "Sleep entries:",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                (SleepEntrys).toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              )
                            ]),
                            Row(children: [
                              const Text(
                                "Temperature entries:",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                (TempEntrys).toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              )
                            ]),
                            Row(children: [
                              const Text(
                                "Throw Up entries: ",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                (VomitEntrys).toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              )
                            ]),
                            Row(children: [
                              const Text(
                                "Vaccine entries:",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                (VaccineEntrys).toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              )
                            ]),
                            const TextDivider(text: "Average of Entries"),
                            Row(children: [
                              const Text(
                                "Feeding (amount in ounces/ entry):",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                (feedingAvg).toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              )
                            ]),
                            Row(children: [
                              const Text(
                                "Liquid Intake (amount in ml/ entry):",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                (liquidAvg).toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              )
                            ]),
                            Row(children: [
                              const Text(
                                "Feeding (duration of nursing in minutes/ entry):",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                (nursingAvg).toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              )
                            ]),
                            Row(children: [
                              const Text(
                                "Sleep Duration (hours/entry): ",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                (sleepAvg).toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              )
                            ]),
                            Row(children: [
                              const Text(
                                "Temperature in farenheit: ",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                (tempAvg).toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              )
                            ]),
                            const TextDivider(text: "Daily averages"),
                            Row(children: [
                              const Text(
                                "Feeding (amount in ounces/ day):",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                (dailyFeed).toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              )
                            ]),
                            Row(children: [
                              const Text(
                                "Liquid intake (amount in ml/ day):",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                (dailyLiquid).toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              )
                            ]),
                            Row(children: [
                              const Text(
                                "Feeding (duration of nursing/ day):",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                (dailyNurse).toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              )
                            ]),
                            Row(children: [
                              const Text(
                                "Sleep Duration in hours/ day: ",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                (dailySleep).toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              )
                            ]),
                            Row(children: [
                              const Text(
                                "Change in height in inches/ day: ",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                (dailyGrowthHeight).toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              )
                            ]),
                            Row(
                                //  mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Change in weight in pounds/ day: ",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    (dailyGrowthWeight).toStringAsFixed(2),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
                                  )
                                ]),
                            Row(children: [
                              const Text(
                                "Change in head circumference in inches/ day: ",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                (dailyGrowthHC).toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white),
                              )
                            ]),
                          ]);
                        } else {
                          return const SizedBox(height: 0);
                        }

                        //log((VaccineEntrys).toString());
                      },
                    );
                  }),
            ]),
          ]),
        ));
  }
}
