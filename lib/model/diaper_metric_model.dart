import 'package:baby_tracks/model/metric_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../component/text_divider.dart';
import '../constants/palette.dart';
import '../view/metric_views/diaper_view.dart';
import '../wrapperClasses/pair.dart';

class DiaperMetricModel extends DiaperMetric implements MetricInterface {
  const DiaperMetricModel({
    required String babyId,
    required DateTime timeCreated,
    required DateTime startTime,
    required String diaperContents,
    required String diaperSize,
    required String notes,
  }) : super(
            babyId: babyId,
            timeCreated: timeCreated,
            startTime: startTime,
            diaperContents: diaperContents,
            diaperSize: diaperSize,
            notes: notes);

  factory DiaperMetricModel.fromJson(Map<String, dynamic> json) {
    return DiaperMetricModel(
      babyId: json['babyId'] ?? "null",
      timeCreated: (json['timeCreated'] as Timestamp).toDate(),
      startTime: (json['startTime'] as Timestamp).toDate(),
      diaperContents: json['diaperContents'],
      diaperSize: json['diaperSize'],
      notes: json['notes'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'babyId': babyId,
        'timeCreated': timeCreated,
        'startTime': startTime,
        'diaperContents': diaperContents,
        'diaperSize': diaperSize,
        'notes': notes
      };

  @override
  Future routeToEdit(dynamic context, String id) async {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DiaperView(Optional.of(Pair(left: id, right: this)));
    }));
  }

  @override
  String getCollectionName() {
    return "Diaper";
  }

  @override
  Widget analyticsWidget() {
    return Column(
      children: [
        const TextDivider(text: 'New Diaper Entry'),
        const TextDivider(text: 'Occured at:'),
        Center(
            child: Text(
          startTime.toString(),
          style: const TextStyle(
            color: ColorPalette.pText,
          ),
        )),
        const TextDivider(text: 'Mess Size'),
        Center(
            child: Text(
          diaperSize,
          style: const TextStyle(
            color: ColorPalette.pText,
          ),
        )),
        const TextDivider(text: 'Contents'),
        Center(
            child: Text(
          diaperContents,
          style: const TextStyle(
            color: ColorPalette.pText,
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

class DiaperMetric extends Equatable {
  final String babyId;
  final DateTime timeCreated;
  final DateTime startTime;
  final String diaperContents;
  final String diaperSize;
  final String notes;

  const DiaperMetric({
    required this.babyId,
    required this.timeCreated,
    required this.startTime,
    required this.diaperContents,
    required this.diaperSize,
    required this.notes,
  });

  @override
  List<Object?> get props =>
      [babyId, timeCreated, startTime, diaperContents, diaperSize, notes];
}
