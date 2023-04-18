import 'package:baby_tracks/model/MetricInterface.dart';
import 'package:baby_tracks/view/metric_views/vaccine_view.dart';
import 'package:baby_tracks/wrapperClasses/pair.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional_internal.dart';

import '../component/text_divider.dart';
import '../constants/palette.dart';

class VaccineMetricModel extends VaccineMetric implements MetricInterface {
  const VaccineMetricModel({
    required String babyId,
    required DateTime timeCreated,
    required DateTime startTime,
    required String vaccine,
    required String series,
    required String notes,
  }) : super(
            babyId: babyId,
            timeCreated: timeCreated,
            startTime: startTime,
            vaccine: vaccine,
            series: series,
            notes: notes);

  factory VaccineMetricModel.fromJson(Map<String, dynamic> json) {
    return VaccineMetricModel(
      babyId: json['babyId'],
      timeCreated: (json['timeCreated'] as Timestamp).toDate(),
      startTime: (json['startTime'] as Timestamp).toDate(),
      vaccine: json['vaccine'],
      series: json['series'].toString(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'babyId': babyId,
        'timeCreated': timeCreated,
        'startTime': startTime,
        'series': double.parse('0' + series),
        'vaccine': vaccine,
        'notes': notes
      };

  @override
  Future routeToEdit(dynamic context, String id) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return VaccineView(Optional.of(Pair(left: id, right: this)));
    }));
  }

  @override
  String getCollectionName() {
    return "Vaccine";
  }

  Widget analyticsWidget() {
    return Container(
      child: Column(
        children: [
          const TextDivider(text: 'New Vaccine Entry'),
          const TextDivider(text: 'Entry Created at:'),
          Center(
              child: Text(
            "$timeCreated",
            style: const TextStyle(
              color: ColorPalette.pText,
            ),
          )),
          const TextDivider(text: 'Vaccine'),
          Center(
              child: Text(
            "$vaccine Series: $series",
            style: const TextStyle(
              color: ColorPalette.pText,
            ),
          )),
          const TextDivider(text: 'Taken at:'),
          Center(
              child: Text(
            "$timeCreated",
            style: const TextStyle(
              color: ColorPalette.pText,
            ),
          )),
          const TextDivider(text: 'Notes'),
          Center(child: Text(notes))
        ],
      ),
    );
  }
}

class VaccineMetric extends Equatable {
  final String babyId;
  final DateTime timeCreated;
  final DateTime startTime;
  final String vaccine;
  final String series;
  final String notes;

  const VaccineMetric({
    required this.babyId,
    required this.timeCreated,
    required this.startTime,
    required this.vaccine,
    required this.series,
    required this.notes,
  });

  @override
  List<Object?> get props =>
      [babyId, timeCreated, startTime, vaccine, series, notes];
}
