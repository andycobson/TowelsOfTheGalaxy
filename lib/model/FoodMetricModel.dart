import 'package:equatable/equatable.dart';

import "package:equatable/equatable.dart";

class FoodMetricModel extends FoodMetric {
  FoodMetricModel({
    required num amount,
    required int time,
    required String notes,
  }) : super(amount: amount, time: time, notes: notes);

  factory FoodMetricModel.fromJson(Map<String, dynamic> json) {
    return FoodMetricModel(
      amount: json['amount'],
      time: json['time'],
      notes: json['notes'],
    );
  }
}

class FoodMetric extends Equatable {
  final num amount; //fluid oz
  final int time; // epoch int
  final String notes;

  FoodMetric({
    required this.amount,
    required this.time,
    required this.notes,
  });

  @override
  List<Object?> get props => [amount, time, notes];
}
