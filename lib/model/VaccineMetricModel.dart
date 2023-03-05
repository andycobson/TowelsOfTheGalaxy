import 'package:equatable/equatable.dart';

class VaccineMetricModel extends VaccineMetric {
  const VaccineMetricModel({
    required String babyId,
    required DateTime timeCreated,
    required DateTime startTime,
    required String vaccine,
    required String series,
    required String notes,
  }) : super(
            babyId: babyId,
            timeCreated: timeCreated,
            startTime: startTime,
            vaccine: vaccine,
            series: series,
            notes: notes);

  factory VaccineMetricModel.fromJson(Map<String, dynamic> json) {
    return VaccineMetricModel(
      babyId: json['babyId'],
      timeCreated: json['timeCreated'],
      startTime: json['startTime'],
      vaccine: json['vaccine'],
      series: json['series'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'babyId': babyId,
        'timeCreated': timeCreated,
        'startTime': startTime,
        'series': double.parse('0' + series),
        'vaccine': vaccine,
        'notes': notes
      };
}

class VaccineMetric extends Equatable {
  final String babyId;
  final DateTime timeCreated;
  final DateTime startTime;
  final String vaccine;
  final String series;
  final String notes;

  const VaccineMetric({
    required this.babyId,
    required this.timeCreated,
    required this.startTime,
    required this.vaccine,
    required this.series,
    required this.notes,
  });

  @override
  List<Object?> get props =>
      [babyId, timeCreated, startTime, vaccine, series, notes];
}
