import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FoodMetricModel extends FoodMetric {
  FoodMetricModel({
    required String Baby_ID,
    required DateTime when,
    required String feedingType,
    required String note,
    required String Amt,
    required String duration,
  }) : super( Baby_ID: Baby_ID, when: when, feedingType: feedingType, note: note, Amt: Amt, duration: duration);

  factory FoodMetricModel.fromJson(Map<String, dynamic> json) {
    return FoodMetricModel(
      Baby_ID: json['Baby_ID'],
      note: json['note'],
      feedingType: json['feedingType'],
      when: json['TimeCreated'],
      Amt: json['FeedingAmt'],
      duration: json['Nursingduration']

    );
  }

  Map<String, dynamic> toJson() => {
        'Baby_ID': Baby_ID,
         'note': note,
        'feedingType': feedingType,
        'TimeCreated': when,
        'FeedingAmt': double.parse('0'+Amt),
        'Nursingduration': double.parse('0'+duration),
       
      };
     
}

class FoodMetric extends Equatable {

  final DateTime when; // epoch int
  final String feedingType;
  final String note;
  final String Baby_ID;
  final String Amt;
  final String duration;


  FoodMetric({
    required this.when,
    required this.note,
    required this.feedingType,
    required this.Baby_ID,
    required this.Amt,
    required this.duration
  });

  @override
  List<Object?> get props => [ when, note, feedingType, Baby_ID, Amt, duration];
}