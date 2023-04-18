import 'package:baby_tracks/model/MetricInterface.dart';
import 'package:baby_tracks/view/metric_views/temperature_view.dart';
import 'package:baby_tracks/wrapperClasses/pair.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional_internal.dart';

import '../component/text_divider.dart';
import '../constants/palette.dart';

class TempMetricModel extends TempMetric implements MetricInterface {
  const TempMetricModel({
    required String babyId,
    required DateTime timeCreated,
    required DateTime tempTime,
    required String temperature,
    required String tempType,
    required String notes,
  }) : super(
          babyId: babyId,
          timeCreated: timeCreated,
          tempTime: tempTime,
          temperature: temperature,
          tempType: tempType,
          notes: notes,
        );

  factory TempMetricModel.fromJson(Map<String, dynamic> json) {
    return TempMetricModel(
      babyId: json['babyId'],
      timeCreated: (json['timeCreated'] as Timestamp).toDate(),
      tempTime: (json['tempTime'] as Timestamp).toDate(),
      temperature: (json['temperature'] ?? 0 as double).toString(),
      tempType: json['tempType'],
      notes: json['notes'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'babyId': babyId,
        'timeCreated': timeCreated,
        'tempTime': tempTime,
        'temperature': double.parse('0' + temperature),
        'tempType': tempType,
        'notes': notes,
      };

  @override
  Future routeToEdit(dynamic context, String id) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TemperatureView(Optional.of(Pair(left: id, right: this)));
    }));
  }

  @override
  String getCollectionName() {
    return "Temperature";
  }

  @override
  Widget analyticsWidget() {
    return Container(
      child: Column(
        children: [
          const TextDivider(text: 'New Temperature Entry'),
          const TextDivider(text: 'Entry posted at:'),
          Center(child: Text("$timeCreated")),
          const TextDivider(text: 'Temperature'),
          Center(
              child: Text(
            "$temperature ° $tempType",
            style: const TextStyle(
              color: ColorPalette.pText,
            ),
          )),
          const TextDivider(text: 'Taken at:'),
          Center(
              child: Text(
            "$tempTime",
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

class TempMetric extends Equatable {
  final String babyId;
  final DateTime timeCreated;
  final DateTime tempTime;
  final String temperature;
  final String tempType;
  final String notes;

  const TempMetric(
      {required this.babyId,
      required this.timeCreated,
      required this.tempTime,
      required this.temperature,
      required this.tempType,
      required this.notes});

  @override
  List<Object?> get props =>
      [babyId, timeCreated, tempTime, temperature, tempType, notes];
}
