import 'package:baby_tracks/model/DiaperMetricModel.dart';
import 'package:baby_tracks/model/babyModel.dart';
import 'package:baby_tracks/model/FoodMetricModel.dart';
import 'package:baby_tracks/model/GrowthMetricModel.dart';
import 'package:baby_tracks/model/SleepMetricModel.dart';
import 'package:baby_tracks/model/TempMetricModel.dart';
import 'package:baby_tracks/model/ThrowUpMetricModel.dart';
import 'package:baby_tracks/model/VaccineMetricModel.dart';
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
  final CollectionReference throwUpCollection =
      FirebaseFirestore.instance.collection('Throwup');
  final CollectionReference vaccineCollection =
      FirebaseFirestore.instance.collection('Vaccine');
  final CollectionReference babyCollection =
      FirebaseFirestore.instance.collection('Baby');

  Future createDiaperMetric(DiaperMetricModel model) async {
    return await diaperCollection.doc().set(model.toJson());
  }

  Future createFoodMetric(FoodMetricModel model) async {
    return await foodCollection.doc().set(model.toJson());
  }

  Future createSleepMetric(SleepMetricModel model) async {
    return await sleepCollection.doc().set(model.toJson());
  }

  Future createGrowthMetric(GrowthMetricModel model) async {
    return await growthCollection.doc().set(model.toJson());
  }

  Future createTemperatureMetric(TempMetricModel model) async {
    return await temperatureCollection.doc().set(model.toJson());
  }

  Future createThrowUpMetric(ThrowUpMetricModel model) async {
    return await throwUpCollection.doc().set(model.toJson());
  }

  Future createVaccineMetric(VaccineMetricModel model) async {
    return await vaccineCollection.doc().set(model.toJson());
  }

  Future createBabyUser(BabyModel model) async {
    return await babyCollection.doc().set(model.toJson());
  }
}
