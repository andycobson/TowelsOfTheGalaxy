import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DiaperMetricModel extends DiaperMetric {
  DiaperMetricModel({
    required String BabyID,
    required DateTime when,
    required String status,
    required String note,
  }) : super( BabyID: BabyID, when: when, status: status, note: note);

  factory DiaperMetricModel.fromJson(Map<String, dynamic> json) {
    return DiaperMetricModel(
      BabyID: json['Baby_ID'],
      note: json['note'],
      status: json['status'],
      when: json['TimeCreated'],

    );
  }

  Map<String, dynamic> toJson() => {
        'Baby_ID': BabyID,
         'note': note,
        'status': status,
        'TimeCreated': when,
       
      };
     
}

class DiaperMetric extends Equatable {

  final DateTime when; // epoch int
  final String status;
  final String note;
  final String BabyID;

  DiaperMetric({
    required this.when,
    required this.note,
    required this.status,
    required this.BabyID,
  });

  @override
  List<Object?> get props => [ when, note, status, BabyID];
}