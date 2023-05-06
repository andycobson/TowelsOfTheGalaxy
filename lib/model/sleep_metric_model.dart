import 'package:baby_tracks/model/metric_interface.dart';
import 'package:baby_tracks/view/metric_views/sleep_view.dart';
import 'package:baby_tracks/wrapperClasses/pair.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../component/text_divider.dart';
import '../constants/palette.dart';

class SleepMetricModel extends SleepMetric implements MetricInterface {
  const SleepMetricModel({
    required String babyId,
    required DateTime timeCreated,
    required DateTime startTime,
    required DateTime endTime,
    required String duration,
    required String notes,
  }) : super(
            babyId: babyId,
            timeCreated: timeCreated,
            startTime: startTime,
            endTime: endTime,
            duration: duration,
            notes: notes);

  factory SleepMetricModel.fromJson(Map<String, dynamic> json) {
    return SleepMetricModel(
      babyId: json['babyId'],
      timeCreated: (json['timeCreated'] as Timestamp).toDate(),
      startTime: (json['startTime'] as Timestamp).toDate(),
      endTime: (json['endTime'] as Timestamp).toDate(),
      duration: (json['Duration'] ?? "").toString(),
      notes: json['notes'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'babyId': babyId,
        'timeCreated': timeCreated,
        'startTime': startTime,
        'endTime': endTime,
        'duration': double.parse('0$duration'),
        'notes': notes,
      };

  @override
  Future routeToEdit(dynamic context, String id) async {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SleepView(Optional.of(Pair(left: id, right: this)));
    }));
  }

  @override
  String getCollectionName() {
    return "Sleep";
  }

  @override
  Widget analyticsWidget() {
    return Column(
      children: [
        const TextDivider(text: 'New Sleep Entry'),
        const TextDivider(text: 'Entry posted at:'),
        Center(
            child: Text(
          "$timeCreated",
          style: const TextStyle(
            color: ColorPalette.pText,
          ),
        )),
        const TextDivider(text: 'Times frame of nap'),
        Center(
            child: Text(
          "$startTime to $endTime",
          style: const TextStyle(
            color: ColorPalette.pText,
          ),
        )),
        const TextDivider(text: 'Duration'),
        Center(
            child: Text(
          "$duration Hours",
          style: const TextStyle(
            color: ColorPalette.pText,
          ),
        )),
        const TextDivider(text: 'Notes'),
        Center(
            child: Text(
          notes,
          style: const TextStyle(
            color: ColorPalette.pText,
          ),
        ))
      ],
    );
  }
}

class SleepMetric extends Equatable {
  final String babyId;
  final DateTime timeCreated;
  final DateTime startTime;
  final DateTime endTime;
  final String duration;
  final String notes;

  const SleepMetric({
    required this.babyId,
    required this.timeCreated,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.notes,
  });

  @override
  List<Object?> get props =>
      [babyId, timeCreated, startTime, endTime, duration, notes];
}
