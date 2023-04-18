import 'package:baby_tracks/model/MetricInterface.dart';
import 'package:baby_tracks/view/metric_views/growth_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../component/text_divider.dart';
import '../constants/palette.dart';
import '../wrapperClasses/pair.dart';

class GrowthMetricModel extends GrowthMetric implements MetricInterface {
  const GrowthMetricModel({
    required String babyId,
    required DateTime timeCreated,
    required String height,
    required String weight,
    required String headCircumference,
    required String notes,
  }) : super(
          babyId: babyId,
          timeCreated: timeCreated,
          height: height,
          weight: weight,
          headCircumference: headCircumference,
          notes: notes,
        );

  factory GrowthMetricModel.fromJson(Map<String, dynamic> json) {
    return GrowthMetricModel(
      babyId: json['babyId'],
      timeCreated: (json['timeCreated'] as Timestamp).toDate(),
      height: (json['height'] ?? 0).toString(),
      weight: (json['weight'] ?? 0).toString(),
      headCircumference: (json['headCircumference'] ?? 0).toString(),
      notes: json['notes'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'babyId': babyId,
        'timeCreated': timeCreated,
        'height': double.parse('0' + height),
        'weight': double.parse('0' + weight),
        'headCircumference': double.parse('0' + headCircumference),
        'notes': notes,
      };

  @override
  Future routeToEdit(dynamic context, String id) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return GrowthView(Optional.of(Pair(left: id, right: this)));
    }));
  }

  @override
  String getCollectionName() {
    return "Growth";
  }

  @override
  Widget analyticsWidget() {
    return Container(
        child: Column(
      children: [
        const TextDivider(text: 'New Growth Entry'),
        const TextDivider(text: 'Occured at:'),
        Center(
            child: Text(
          "$timeCreated",
          style: const TextStyle(
            color: ColorPalette.pText,
          ),
        )),
        const TextDivider(text: 'Head Circumference'),
        Center(
            child: Text(
          "$headCircumference Inches",
          style: const TextStyle(
            color: ColorPalette.pText,
          ),
        )),
        const TextDivider(text: 'Height'),
        Center(
            child: Text(
          "$height Inches",
          style: const TextStyle(
            color: ColorPalette.pText,
          ),
        )),
        const TextDivider(text: 'Weight'),
        Center(
            child: Text(
          "$weight Pounds",
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
    ));
  }
}

class GrowthMetric extends Equatable {
  final String babyId;
  final DateTime timeCreated;
  final String height;
  final String weight;
  final String headCircumference;
  final String notes;

  const GrowthMetric({
    required this.babyId,
    required this.timeCreated,
    required this.height,
    required this.weight,
    required this.headCircumference,
    required this.notes,
  });

  @override
  List<Object?> get props =>
      [babyId, timeCreated, height, weight, headCircumference, notes];
}
