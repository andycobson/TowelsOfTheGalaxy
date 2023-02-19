import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SleepMetricModel extends SleepMetric {
  SleepMetricModel({
    required String Baby_ID,
    required DateTime when,
    required DateTime start,
    required DateTime end,
    required String dur,
    required String note,
  }) : super( Baby_ID: Baby_ID, when: when, dur: dur, start: start, end: end, note: note);

  factory SleepMetricModel.fromJson(Map<String, dynamic> json) {
    return SleepMetricModel(
      Baby_ID: json['Baby_ID'],
      start: json['StartTime'],
      end: json['EndTime'],
      note: json['note'],
      dur: json['Duration'],
      when: json['TimeCreated'],

    );
  }

  Map<String, dynamic> toJson() => {
        'Baby_ID': Baby_ID,
         'note': note,
         'StartTime': start,
         'EndTime': end,
        'Duration': double.parse('0'+dur),
        'TimeCreated': when,
       
      };
     
}

class SleepMetric extends Equatable {

  final DateTime when; // epoch int
  final String dur;
  final DateTime start;
  final DateTime end;
  final String note;
  final String Baby_ID;

  SleepMetric({
    required this.when,
    required this.start,
    required this.end,
    required this.note,
    required this.dur,
    required this.Baby_ID,
  });

  @override
  List<Object?> get props => [ when, note, start, end, dur, Baby_ID];
}