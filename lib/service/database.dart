import 'dart:developer';

import 'package:baby_tracks/model/DiaperMetricModel.dart';
import 'package:baby_tracks/model/FoodMetricModel.dart';
import 'package:baby_tracks/model/GrowthMetricModel.dart';
import 'package:baby_tracks/model/SleepMetricModel.dart';
import 'package:baby_tracks/model/TempMetricModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference diaperCollection =
      FirebaseFirestore.instance.collection('Diaper');
  final CollectionReference foodCollection =
      FirebaseFirestore.instance.collection('Food');
  final CollectionReference sleepCollection =
      FirebaseFirestore.instance.collection('Sleep');
  final CollectionReference growthCollection =
      FirebaseFirestore.instance.collection('Growth');
  final CollectionReference temperatureCollection =
      FirebaseFirestore.instance.collection('Temperature');

  Future updateDiaperMetric(DiaperMetricModel model) async {
    return await diaperCollection.doc().set(model.toJson());
  }

  Future updateFooodMetric(FoodMetricModel model) async {
    return await foodCollection.doc().set(model.toJson());
  }

  Future updateSleepMetric(SleepMetricModel model) async {
    return await sleepCollection.doc().set(model.toJson());
  }

  Future updateGrowthMetric(GrowthMetricModel model) async {
    return await growthCollection.doc().set(model.toJson());
  }

  Future updateTemperatureMetric(TempMetricModel model) async {
    return await temperatureCollection.doc().set(model.toJson());
  }
}
