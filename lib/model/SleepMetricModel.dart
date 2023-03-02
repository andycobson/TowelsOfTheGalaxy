import 'package:equatable/equatable.dart';

class SleepMetricModel extends SleepMetric {
  const SleepMetricModel({
    required String babyId,
    required DateTime timeCreated,
    required DateTime startTime,
    required DateTime endTime,
    required String duration,
    required String notes,
  }) : super(
            babyId: babyId,
            timeCreated: timeCreated,
            startTime: startTime,
            endTime: endTime,
            duration: duration,
            notes: notes);

  factory SleepMetricModel.fromJson(Map<String, dynamic> json) {
    return SleepMetricModel(
      babyId: json['babyId'],
      timeCreated: json['timeCreated'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      duration: json['Duration'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'babyId': babyId,
        'timeCreated': timeCreated,
        'startTime': startTime,
        'endTime': endTime,
        'duration': double.parse('0' + duration),
        'notes': notes,
      };
}

class SleepMetric extends Equatable {
  final String babyId;
  final DateTime timeCreated;
  final DateTime startTime;
  final DateTime endTime;
  final String duration;
  final String notes;

  const SleepMetric({
    required this.babyId,
    required this.timeCreated,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.notes,
  });

  @override
  List<Object?> get props =>
      [babyId, timeCreated, startTime, endTime, duration, notes];
}
