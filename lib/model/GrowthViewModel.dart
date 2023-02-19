import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GrowthMetricModel extends GrowthMetric {
  GrowthMetricModel({
    required String Baby_ID,
    required DateTime when,

    required String note,
    required String height,
    required String weight,
    required String headCircumference,
  }) : super( Baby_ID: Baby_ID, when: when, note: note, height: height, weight: weight, headCircumference: headCircumference);

  factory GrowthMetricModel.fromJson(Map<String, dynamic> json) {
    return GrowthMetricModel(
      Baby_ID: json['Baby_ID'],
      note: json['note'],
    
      when: json['TimeCreated'],
      height: json['height'],
      weight: json['weight'],
      headCircumference: json['head_circumference']

    );
  }

  Map<String, dynamic> toJson() => {
        'Baby_ID': Baby_ID,
         'note': note,
       
        'TimeCreated': when,
        'height': double.parse('0'+height),
        'weight': double.parse('0'+weight),
        'head_circumference': double.parse('0'+headCircumference)
       
      };
     
}

class GrowthMetric extends Equatable {

  final DateTime when; // epoch int

  final String note;
  final String Baby_ID;
  final String height;
  final String weight;
  final String headCircumference;


  GrowthMetric({
    required this.when,
    required this.note,

    required this.Baby_ID,
    required this.height,
    required this.weight,
    required this.headCircumference
  });

  @override
  List<Object?> get props => [ when, note, Baby_ID, height, weight, headCircumference];
}