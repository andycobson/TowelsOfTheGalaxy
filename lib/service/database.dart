import 'dart:convert';
import 'dart:developer';
import 'package:baby_tracks/model/MedicineMetricModel.dart';
import 'package:baby_tracks/model/DiaperMetricModel.dart';
import 'package:baby_tracks/model/babyModel.dart';
import 'package:baby_tracks/model/FoodMetricModel.dart';
import 'package:baby_tracks/model/GrowthMetricModel.dart';
import 'package:baby_tracks/model/SleepMetricModel.dart';
import 'package:baby_tracks/model/TempMetricModel.dart';
import 'package:baby_tracks/model/ThrowUpMetricModel.dart';
import 'package:baby_tracks/model/VaccineMetricModel.dart';
import 'package:baby_tracks/model/persistentUser.dart';
import 'package:baby_tracks/wrapperClasses/pair.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  final CollectionReference medicineCollection =
      FirebaseFirestore.instance.collection('Medicine');
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
  final CollectionReference throwupCollection =
      FirebaseFirestore.instance.collection('Throwup');
  final CollectionReference vaccineCollection =
      FirebaseFirestore.instance.collection('Vaccine');
  final CollectionReference babyCollection =
      FirebaseFirestore.instance.collection('Baby');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Users");

  Future createDiaperMetric(DiaperMetricModel model) async {
    return await diaperCollection.doc().set(model.toJson());
  }

  Future createMedicineMetric(MedicineMetricModel model) async {
    return await medicineCollection.doc().set(model.toJson());
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
    return await throwupCollection.doc().set(model.toJson());
  }

  Future createVaccineMetric(VaccineMetricModel model) async {
    return await vaccineCollection.doc().set(model.toJson());
  }

  Future createBabyUser(BabyModel model) async {
    return await babyCollection.doc().set(model.toJson());
  }

  Future editMedicineMetric(MedicineMetricModel model, String id) async {
    return await diaperCollection.doc(id).update(model.toJson());
  }

  Future editDiaperMetric(DiaperMetricModel model, String id) async {
    return await diaperCollection.doc(id).update(model.toJson());
  }

  Future editFoodMetric(FoodMetricModel model, String id) async {
    return await foodCollection.doc(id).update(model.toJson());
  }

  Future editSleepMetric(SleepMetricModel model, String id) async {
    return await sleepCollection.doc(id).update(model.toJson());
  }

  Future editGrowthMetric(GrowthMetricModel model, String id) async {
    return await growthCollection.doc(id).update(model.toJson());
  }

  Future editTemperatureMetric(TempMetricModel model, String id) async {
    return await temperatureCollection.doc(id).update(model.toJson());
  }

  Future editThrowUpMetric(ThrowUpMetricModel model, String id) async {
    return await throwupCollection.doc(id).update(model.toJson());
  }

  Future editVaccineMetric(VaccineMetricModel model, String id) async {
    return await vaccineCollection.doc(id).update(model.toJson());
  }

  Future deleteMedicineMetric(String id) async {
    return await medicineCollection.doc(id).delete();
  }

  Future deleteDiaperMetric(String id) async {
    return await diaperCollection.doc(id).delete();
  }

  Future deleteFoodMetric(String id) async {
    return await foodCollection.doc(id).delete();
  }

  Future deleteSleepMetric(String id) async {
    return await sleepCollection.doc(id).delete();
  }

  Future deleteGrowthMetric(String id) async {
    return await growthCollection.doc(id).delete();
  }

  Future deleteTemperatureMetric(String id) async {
    return await temperatureCollection.doc(id).delete();
  }

  Future deleteThrowUpMetric(String id) async {
    return await throwupCollection.doc(id).delete();
  }

  Future deleteVaccineMetric(String id) async {
    return await vaccineCollection.doc(id).delete();
  }

  Future<List<Pair>> retreiveAllAsList(
      DateTime startDate, DateTime endDate, String babyId) async {
    List<Pair> res = [];
    res.addAll(await timeQuery(startDate, endDate, "Medicine", babyId));
    res.addAll(await timeQuery(startDate, endDate, "Diaper", babyId));
    res.addAll(await timeQuery(startDate, endDate, "Food", babyId));
    res.addAll(await timeQuery(startDate, endDate, "Growth", babyId));
    res.addAll(await timeQuery(startDate, endDate, "Sleep", babyId));
    res.addAll(await timeQuery(startDate, endDate, "Temperature", babyId));
    res.addAll(await timeQuery(startDate, endDate, "Throwup", babyId));
    res.addAll(await timeQuery(startDate, endDate, "Vaccine", babyId));
    return res;
  }

  Future nuke(String babyId) async {
    DateTime startDate = DateTime(
        DateTime.now().subtract(const Duration(days: 60)).year,
        DateTime.now().subtract(const Duration(days: 60)).month,
        DateTime.now().subtract(const Duration(days: 60)).day);
    DateTime endDate = DateTime(
        DateTime.now().add(const Duration(days: 1)).year,
        DateTime.now().add(const Duration(days: 1)).month,
        DateTime.now().add(const Duration(days: 1)).day);
    List<Pair> res = [];
    res.addAll(await timeQuery(startDate, endDate, "Diaper", babyId));
    res.forEach((element) {
      deleteDiaperMetric(element.left);
    });
    res.addAll(await timeQuery(startDate, endDate, "Medicine", babyId));
    res.forEach((element) {
      deleteMedicineMetric(element.left);
    });
    res.addAll(await timeQuery(startDate, endDate, "Food", babyId));
    res.clear();
    res.forEach((element) {
      deleteFoodMetric(element.left);
    });
    res.clear();
    res.addAll(await timeQuery(startDate, endDate, "Growth", babyId));
    res.forEach((element) {
      deleteGrowthMetric(element.left);
    });
    res.clear();
    res.addAll(await timeQuery(startDate, endDate, "Sleep", babyId));
    res.forEach((element) {
      deleteSleepMetric(element.left);
    });
    res.clear();
    res.addAll(await timeQuery(startDate, endDate, "Temperature", babyId));
    res.forEach((element) {
      deleteTemperatureMetric(element.left);
    });
    res.clear();
    res.addAll(await timeQuery(startDate, endDate, "Throwup", babyId));
    res.forEach((element) {
      deleteThrowUpMetric(element.left);
    });
    res.clear();
    res.addAll(await timeQuery(startDate, endDate, "Vaccine", babyId));
    res.forEach((element) {
      deleteVaccineMetric(element.left);
    });
    res.clear();
  }

  Future<List<Pair>> timeQuery(DateTime startDate, DateTime endDate,
      String metricType, String babyId) async {
    Map<String, Pair> dataMap = {
      "Medicine":
          Pair(left: MedicineMetricModel.fromJson, right: medicineCollection),
      "Diaper": Pair(left: DiaperMetricModel.fromJson, right: diaperCollection),
      "Food": Pair(left: FoodMetricModel.fromJson, right: foodCollection),
      "Growth": Pair(left: GrowthMetricModel.fromJson, right: growthCollection),
      "Sleep": Pair(left: SleepMetricModel.fromJson, right: sleepCollection),
      "Temperature":
          Pair(left: TempMetricModel.fromJson, right: temperatureCollection),
      "Throwup":
          Pair(left: ThrowUpMetricModel.fromJson, right: throwupCollection),
      "Vaccine":
          Pair(left: VaccineMetricModel.fromJson, right: vaccineCollection),
    };

    CollectionReference colRef = dataMap[metricType]!.right;

    log(babyId);

    QuerySnapshot shapShots = await colRef
        .where('timeCreated', isGreaterThanOrEqualTo: startDate)
        .where('timeCreated', isLessThanOrEqualTo: endDate)
        .where('babyId', isEqualTo: babyId)
        .get();

    List<Pair> res = [];
    List<QueryDocumentSnapshot> docs = [];

    final allData = shapShots.docs
        .map((e) => Pair(left: e.id, right: e.data() as Map<String, dynamic>))
        .toList();

    Function fromJson = dataMap[metricType]!.left;

    allData.forEach(
      (pair) => res.add(Pair(left: pair.left, right: fromJson(pair.right))),
    );
    return res;
  }

  Future updateUserState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = PersistentUser.instance.userId;
    var currentLocalState = preferences.getString(userId);

    preferences.setString(
        userId, json.encode(PersistentUser.instance.toJson()));

    var doc = await userCollection.doc(userId).get();
    bool exists = doc.exists;
    
  }
}
