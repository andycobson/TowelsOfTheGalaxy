import 'package:baby_tracks/component/text_divider.dart';
import 'package:baby_tracks/model/growth_metric_model.dart';
import 'package:baby_tracks/model/sleep_metric_model.dart';
import 'package:baby_tracks/model/temp_metric_model.dart';
import 'package:flutter/material.dart';

import '../../constants/palette.dart';
import '../../model/food_metric_model.dart';
import '../../model/persistent_user.dart';
import '../../service/database.dart';
import '../../wrapperClasses/pair.dart';

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
                          builder: (context) => SearchRoute(
                              startDate: dateA,
                              endDate: dateB.add(const Duration(days: 1)))),
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

class SearchRoute extends StatefulWidget {
  DateTime defaultStartDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime defaultEndDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .add(const Duration(days: 1));

  int amtOfDays = 0;

  SearchRoute({super.key, required startDate, required endDate}) {
    defaultStartDate = startDate;
    defaultEndDate = endDate;
    amtOfDays = ((defaultEndDate.difference(defaultStartDate)).inDays) + 1;
  }

  @override
  State<SearchRoute> createState() => _SearchRouteState();
}

class _SearchRouteState extends State<SearchRoute> {
  int numOfDiaperEntrys = 0;

  int numOfFoodEntrys = 0;

  int numOfThrowupEntrys = 0;

  int numOfGrowthEntrys = 0;

  int numOfMedicineEntrys = 0;

  int numOfSleepEntrys = 0;

  int numOfVaccineEntrys = 0;

  int numOfTempEntrys = 0;

  int x = 1;

  int amtOfDaysGrowth = 0;

  double totSleep = 0;

  double totFeeding = 0;

  double totLiquid = 0;

  double totNursing = 0;

  double totTemp = 0;

  int sleepRan = 0;

  int feedingRan = 0;

  int tempRan = 0;

  int growthRan = 0;

  double changeHeight = 0;

  double changeWeight = 0;

  double changeHead = 0;

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

  late final DatabaseService _service;

  late String babyName;

  late String userId;

  @override
  void initState() {
    super.initState();
    _service = DatabaseService();
    babyName = PersistentUser.instance.currentBabyName;
    userId = PersistentUser.instance.userId;
  }

  Future calculateDiaperAnalytics() async {
    List<Pair> diaperMetrics = await _service.timeQuery(widget.defaultStartDate,
        widget.defaultEndDate, "Diaper", "$userId#$babyName");

    numOfDiaperEntrys = diaperMetrics.length;
  }

  Future calculateFoodAnalytics() async {
    List<Pair> foodMetrics = await _service.timeQuery(widget.defaultStartDate,
        widget.defaultEndDate, "Food", "$userId#$babyName");
    numOfFoodEntrys = foodMetrics.length;
    int numOfNursing = 0;
    int numOfMlFeed = 0;
    int numOfOzFeed = 0;
    for (var i = 0; i < numOfFoodEntrys; i++) {
      Map<String, dynamic> element =
          (foodMetrics.elementAt(i).right as FoodMetricModel).toJson();

      if ((element['metricType'] == "oz")) {
        totFeeding = totFeeding + (element['amount']);
        numOfOzFeed++;
      } else if ((element['metricType'] == "ml")) {
        totLiquid = totLiquid + (element['amount']);
        numOfMlFeed++;
      }
      if (element['feedingType'] == "Nursing") {
        numOfNursing++;
        totNursing = totNursing + (element['duration']);
      }
    }
    if(numOfOzFeed != 0)
      {
        feedingAvg = totFeeding / numOfOzFeed;
      }
    if(numOfMlFeed != 0)
    {
      liquidAvg = totLiquid / numOfMlFeed;
    }
    if(numOfNursing != 0)
    {
      nursingAvg = totNursing / numOfNursing;
    }
    dailyFeed = totFeeding / widget.amtOfDays;
    dailyNurse = totNursing / widget.amtOfDays;
    dailyLiquid = totLiquid / widget.amtOfDays;
  }

  Future calculateGrowthAnalytics() async {
    List<Pair> growthMetrics = await _service.timeQuery(widget.defaultStartDate,
        widget.defaultEndDate, "Growth", "$userId#$babyName");

    numOfGrowthEntrys = growthMetrics.length;

    DateTime earliestDate = DateTime(2030);
    DateTime latestDate = DateTime(2016);

    double earliestHeight = 0;
    double earliestWeight = 0;
    double earliestHC = 0;

    double latestHeight = 0;
    double latestWeight = 0;
    double latestHC = 0;

    for (var i = 0; i < numOfGrowthEntrys; i++) {
      Map<String, dynamic> element =
          (growthMetrics.elementAt(i).right as GrowthMetricModel).toJson();

      DateTime tempTime = element['timeCreated'];
      if (tempTime.isAfter(latestDate)) {
        latestDate = tempTime;
        if ((element['weightType']) == 'lb') {
          latestWeight = (element['weight']);
        } else if ((element['weightType']) == 'kg') {
          latestWeight = ((element['weight']) * 2.2);
        }
        if ((element['heightType']) == 'in') {
          latestHeight = (element['height']);
        } else if ((element['heightType']) == 'cm') {
          latestHeight = ((element['height']) / 2.54);
        }
        if ((element['HCType']) == 'in') {
          latestHC = (element['headCircumference']);
        } else if ((element['HCType']) == 'cm') {
          latestHC = ((element['headCircumference']) / 2.54);
        }
        //  latestHeight = (element['height']);
        //  latestWeight = (element['weight']);
        //  latestHC = (element['headCircumference']);
      }

      if (tempTime.isBefore(earliestDate)) {
        earliestDate = tempTime;
        // height conversion
        if ((element['weightType']) == 'lb') {
          earliestWeight = (element['weight']);
        } else if ((element['weightType']) == 'kg') {
          earliestWeight = ((element['weight']) * 2.2);
        }
        if ((element['heightType']) == 'in') {
          earliestHeight = (element['height']);
        } else if ((element['heightType']) == 'cm') {
          earliestHeight = ((element['height']) / 2.54);
        }
        if ((element['HCType']) == 'in') {
          earliestHC = (element['headCircumference']);
        } else if ((element['HCType']) == 'cm') {
          earliestHC = ((element['headCircumference']) / 2.54);
        }
        // earliestHeight = (snapshot.data?.docs[i]['height']);
        //  earliestWeight = (snapshot.data?.docs[i]['weight']);
        // earliestHC = (snapshot.data?.docs[i]['headCircumference']);
      }
    }
    changeHead = latestHC - earliestHC;
    changeHeight = latestHeight - earliestHeight;
    changeWeight = latestWeight - earliestWeight;
    amtOfDaysGrowth = ((latestDate.difference(earliestDate)).inDays) + 1;

    dailyGrowthHeight = changeHeight / amtOfDaysGrowth;
    dailyGrowthWeight = changeWeight / amtOfDaysGrowth;
    dailyGrowthHC = changeHead / amtOfDaysGrowth;
  }

  Future calculateMedicineAnalytics() async {
    List<Pair> medicineMetrics = await _service.timeQuery(
        widget.defaultStartDate,
        widget.defaultEndDate,
        "Medicine",
        "$userId#$babyName");
    numOfMedicineEntrys = medicineMetrics.length;
  }

  Future calculateSleepAnalytics() async {
    List<Pair> sleepMetrics = await _service.timeQuery(widget.defaultStartDate,
        widget.defaultEndDate, "Sleep", "$userId#$babyName");
    numOfSleepEntrys = sleepMetrics.length;

    for (var i = 0; i < numOfSleepEntrys; i++) {
      Map<String, dynamic> element =
          (sleepMetrics.elementAt(i).right as SleepMetricModel).toJson();
      totSleep = totSleep + (element['duration']);
    }

    sleepAvg = totSleep / numOfSleepEntrys;
    dailySleep = totSleep / widget.amtOfDays;
  }

  Future calculateTemperatureAnalystics() async {
    List<Pair> temperatureMetrics = await _service.timeQuery(
        widget.defaultStartDate,
        widget.defaultEndDate,
        "Temperature",
        "$userId#$babyName");
    numOfTempEntrys = temperatureMetrics.length;
    for (var i = 0; i < numOfTempEntrys; i++) {
      Map<String, dynamic> element =
          (temperatureMetrics.elementAt(i).right as TempMetricModel).toJson();
      if ((element['tempType']) == 'F') {
        totTemp = totTemp + (element['temperature']);
      } else if ((element['tempType']) == 'C') {
        totTemp = totTemp + (((element['temperature']) * 1.8) + 32);
      }
    }

    tempAvg = totTemp / numOfTempEntrys;
  }

  Future calculateThrowUpAnalytics() async {
    List<Pair> throwupMetrics = await _service.timeQuery(
        widget.defaultStartDate,
        widget.defaultEndDate,
        "Throwup",
        "$userId#$babyName");
    numOfThrowupEntrys = throwupMetrics.length;
  }

  Future calculateVaccineAnalytics() async {
    List<Pair> vaccineMetrics = await _service.timeQuery(
        widget.defaultStartDate,
        widget.defaultEndDate,
        "Vaccine",
        "$userId#$babyName");

    numOfVaccineEntrys = vaccineMetrics.length;
  }

  Future calculateAnalytics() async {
    await calculateThrowUpAnalytics();
    await calculateDiaperAnalytics();
    await calculateFoodAnalytics();
    await calculateGrowthAnalytics();
    await calculateMedicineAnalytics();
    await calculateSleepAnalytics();
    await calculateTemperatureAnalystics();
    await calculateVaccineAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Metric Analytics'),
          backgroundColor: ColorPalette.backgroundRGB,
          elevation: 0,
        ),
        backgroundColor: ColorPalette.backgroundRGB,
        body: SingleChildScrollView(
          child: FutureBuilder(
              future: calculateAnalytics(),
              builder: (context, snap) {
                switch (snap.connectionState) {
                  case ConnectionState.done:
                    return Column(children: [
                      const TextDivider(text: "Amount of Entries"),
                      Row(children: [
                        const Text(
                          "Diaper entries:",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          (numOfDiaperEntrys).toString(),
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
                          (numOfFoodEntrys).toString(),
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
                          (numOfGrowthEntrys).toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        )
                      ]),
                      Row(children: [
                        const Text(
                          "Medicine entries:",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          (numOfMedicineEntrys).toString(),
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
                          (numOfSleepEntrys).toString(),
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
                          (numOfTempEntrys).toString(),
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
                          (numOfThrowupEntrys).toString(),
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
                          (numOfVaccineEntrys).toString(),
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
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              }),
        ));
  }
}
