import 'package:baby_tracks/model/MetricInterface.dart';
import 'package:baby_tracks/view/metric_views/throwup_view.dart';
import 'package:baby_tracks/wrapperClasses/pair.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional_internal.dart';

import '../component/text_divider.dart';
import '../constants/palette.dart';

class ThrowUpMetricModel extends ThrowUpMetric implements MetricInterface {
  const ThrowUpMetricModel({
    required String babyId,
    required DateTime timeCreated,
    required DateTime startTime,
    required String throwUpColor,
    required String amount,
    required String notes,
  }) : super(
            babyId: babyId,
            timeCreated: timeCreated,
            startTime: startTime,
            throwUpColor: throwUpColor,
            amount: amount,
            notes: notes);

  factory ThrowUpMetricModel.fromJson(Map<String, dynamic> json) {
    return ThrowUpMetricModel(
      babyId: json['babyId'],
      timeCreated: (json['timeCreated'] as Timestamp).toDate(),
      startTime: (json['startTime'] as Timestamp).toDate(),
      throwUpColor: json['throwUpColor'],
      amount: json['amount'],
      notes: json['notes'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'babyId': babyId,
        'timeCreated': timeCreated,
        'startTime': startTime,
        'amount': amount,
        'throwUpColor': throwUpColor,
        'notes': notes
      };

  @override
  Future routeToEdit(dynamic context, String id) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ThrowUpView(Optional.of(Pair(left: id, right: this)));
    }));
  }

  @override
  String getCollectionName() {
    return "Throwup";
  }

  @override
  Widget analyticsWidget() {
    return Container(
      child: Column(
        children: [
          const TextDivider(text: 'New Throw Up Entry'),
          const TextDivider(text: 'Entry Created at:'),
          Center(
              child: Text(
            "$timeCreated",
            style: const TextStyle(
              color: ColorPalette.pText,
            ),
          )),
          const TextDivider(text: 'Color'),
          Center(
              child: Text(
            throwUpColor,
            style: const TextStyle(
              color: ColorPalette.pText,
            ),
          )),
          const TextDivider(text: 'Amount'),
          Center(child: Text(amount)),
          const TextDivider(text: 'Taken at:'),
          Center(
              child: Text(
            "$startTime",
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
      ),
    );
  }
}

class ThrowUpMetric extends Equatable {
  final String babyId;
  final DateTime timeCreated;
  final DateTime startTime;
  final String throwUpColor;
  final String amount;
  final String notes;

  const ThrowUpMetric({
    required this.babyId,
    required this.timeCreated,
    required this.startTime,
    required this.throwUpColor,
    required this.amount,
    required this.notes,
  });

  @override
  List<Object?> get props =>
      [babyId, timeCreated, startTime, throwUpColor, amount, notes];
}
