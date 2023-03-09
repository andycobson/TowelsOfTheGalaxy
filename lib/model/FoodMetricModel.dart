import 'package:equatable/equatable.dart';

class FoodMetricModel extends FoodMetric {
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
      timeCreated: json['timeCreated'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      feedingType: json['feedingType'],
      metricType: json['metricType'],
      amount: json['amount'],
      duration: json['duration'],
      notes: json['notes'],
    );
  }

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
