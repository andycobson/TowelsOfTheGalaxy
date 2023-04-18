import 'dart:developer';

import 'package:baby_tracks/component/text_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../../constants/palette.dart';
import '../../model/MetricInterface.dart';
import '../../model/persistentUser.dart';
import '../../service/database.dart';
import '../../wrapperClasses/pair.dart';
import '../metric_views/diaper_view.dart';
import '../metric_views/food_view.dart';
import '../metric_views/growth_view.dart';
import '../metric_views/sleep_view.dart';
import '../metric_views/temperature_view.dart';
import '../metric_views/throwup_view.dart';
import '../metric_views/vaccine_view.dart';

class DaysView extends StatefulWidget {
  const DaysView({super.key});

  @override
  State<DaysView> createState() => _DaysViewState();
}

class _DaysViewState extends State<DaysView> {
  DateTime startDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime endDate = DateTime(
      DateTime.now().add(Duration(days: 1)).year,
      DateTime.now().add(Duration(days: 1)).month,
      DateTime.now().add(Duration(days: 1)).day);

  late DatabaseService _service;

  String babyName = PersistentUser.instance.currentBabyName;
  String userId = PersistentUser.instance.userId;

  @override
  void initState() {
    _service = DatabaseService();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Entries'),
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
                      .retreiveAllAsList(
                          startDate, endDate, "$userId#$babyName")
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
