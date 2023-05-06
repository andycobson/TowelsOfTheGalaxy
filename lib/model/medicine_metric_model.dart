import 'package:baby_tracks/model/metric_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../component/text_divider.dart';
import '../constants/palette.dart';
import '../view/metric_views/medicine_view.dart';
import '../wrapperClasses/pair.dart';

class MedicineMetricModel extends MedicineMetric implements MetricInterface {
  const MedicineMetricModel({
    required String babyId,
    required DateTime timeCreated,
    required DateTime startTime,
    required String notes,
    required String medicineName,
    required String dose,
  }) : super(
            babyId: babyId,
            timeCreated: timeCreated,
            startTime: startTime,
            dose: dose,
            medicineName: medicineName,
            notes: notes);

  factory MedicineMetricModel.fromJson(Map<String, dynamic> json) {
    return MedicineMetricModel(
      babyId: json['babyId'] ?? "null",
      timeCreated: (json['timeCreated'] as Timestamp).toDate(),
      startTime: (json['startTime'] as Timestamp).toDate(),
      dose: (json['dose'] ?? 0).toString(),
      medicineName: json['medicineName'],
      notes: json['notes'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'dose': dose,
        'medicineName': medicineName,
        'babyId': babyId,
        'timeCreated': timeCreated,
        'startTime': startTime,
        'notes': notes
      };

  @override
  Future routeToEdit(dynamic context, String id) async {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MedicineView(Optional.of(Pair(left: id, right: this)));
    }));
  }

  @override
  String getCollectionName() {
    return "Medicine";
  }

  @override
  Widget analyticsWidget() {
    return Column(
      children: [
        const TextDivider(text: 'New Medicine Entry'),
        const TextDivider(text: 'Occured at:'),
        Center(
            child: Text(
          timeCreated.toString(),
          style: const TextStyle(
            color: ColorPalette.pText,
          ),
        )),
        const TextDivider(text: 'Medicine Name'),
        Center(
            child: Text(
          medicineName,
          style: const TextStyle(
            color: Colors.white,
          ),
        )),
        const TextDivider(text: 'Dosage'),
        Center(
            child: Text(
          "$dose ml",
          style: const TextStyle(
            color: Colors.white,
          ),
        )),
        const TextDivider(text: 'Time Taken'),
        Center(
            child: Text(
          startTime.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        )),
        const TextDivider(text: 'Notes'),
        Center(
            child: Text(
          notes,
          style: const TextStyle(
            color: Colors.white,
          ),
        )),
      ],
    );
  }
}

class MedicineMetric extends Equatable {
  final String babyId;
  final DateTime timeCreated;
  final DateTime startTime;
  final String notes;
  final String dose;
  final String medicineName;

  const MedicineMetric({
    required this.babyId,
    required this.timeCreated,
    required this.startTime,
    required this.notes,
    required this.dose,
    required this.medicineName,
  });

  @override
  List<Object?> get props =>
      [babyId, timeCreated, startTime, dose, medicineName, notes];
}
