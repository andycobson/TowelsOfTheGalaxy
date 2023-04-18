import 'package:baby_tracks/model/MetricInterface.dart';
import 'package:baby_tracks/view/metric_views/food_view.dart';
import 'package:baby_tracks/wrapperClasses/pair.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../component/text_divider.dart';
import '../constants/palette.dart';

class FoodMetricModel extends FoodMetric implements MetricInterface {
  const FoodMetricModel({
    required String babyId,
    required DateTime timeCreated,
    required DateTime startTime,
    required DateTime endTime,
    required String feedingType,
    required String metricType,
    required String amount,
    required String duration,
    required String notes,
  }) : super(
          babyId: babyId,
          timeCreated: timeCreated,
          startTime: startTime,
          endTime: endTime,
          feedingType: feedingType,
          metricType: metricType,
          amount: amount,
          duration: duration,
          notes: notes,
        );

  factory FoodMetricModel.fromJson(Map<String, dynamic> json) {
    return FoodMetricModel(
      babyId: json['babyId'],
      timeCreated: (json['timeCreated'] as Timestamp).toDate(),
      startTime: (json['startTime'] as Timestamp).toDate(),
      endTime: (json['endTime'] as Timestamp).toDate(),
      feedingType: json['feedingType'],
      metricType: json['metricType'],
      amount: (json['amount'] ?? 0).toString(),
      duration: (json['duration'] ?? 0).toString(),
      notes: json['notes'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'babyId': babyId,
        'timeCreated': timeCreated,
        'startTime': startTime,
        'endTime': endTime,
        'feedingType': feedingType,
        'metricType': metricType,
        'amount': double.parse('0' + amount),
        'duration': double.parse('0' + duration),
        'notes': notes,
      };

  @override
  Future routeToEdit(dynamic context, String id) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FoodView(Optional.of(Pair(left: id, right: this)));
    }));
  }

  @override
  String getCollectionName() {
    return "Food";
  }

  @override
  Widget analyticsWidget() {
    return Container(
      child: Column(children: [
        const TextDivider(text: 'New Food Entry'),
        const TextDivider(text: 'Occured at:'),
        Center(
            child: Text(
          timeCreated.toString(),
          style: const TextStyle(
            color: ColorPalette.pText,
          ),
        )),
        const TextDivider(text: 'Nursing, Feeding, or Both?'),
        Center(
            child: Text(
          feedingType,
          style: const TextStyle(
            color: ColorPalette.pText,
          ),
        )),
        const TextDivider(text: 'Feeding Amount'),
        Center(
            child: Text(
          "$amount $metricType",
          style: const TextStyle(
            color: ColorPalette.pText,
          ),
        )),
        const TextDivider(text: 'Times of Nursing'),
        Center(
            child: Text(
          '$startTime to $endTime',
          style: const TextStyle(
            color: ColorPalette.pText,
          ),
        )),
        const TextDivider(text: 'Nursing Duration'),
        Center(
            child: Text(
          "$duration Minutes",
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
      ]),
    );
  }
}

class FoodMetric extends Equatable {
  final String babyId;
  final DateTime timeCreated;
  final DateTime startTime;
  final DateTime endTime;
  final String feedingType;
  final String metricType;
  final String amount;
  final String duration;
  final String notes;

  const FoodMetric({
    required this.babyId,
    required this.timeCreated,
    required this.startTime,
    required this.endTime,
    required this.feedingType,
    required this.metricType,
    required this.amount,
    required this.duration,
    required this.notes,
  });

  @override
  List<Object?> get props => [
        babyId,
        timeCreated,
        startTime,
        endTime,
        feedingType,
        metricType,
        amount,
        duration,
        notes
      ];
}
