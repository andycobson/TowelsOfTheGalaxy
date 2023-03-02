import 'package:equatable/equatable.dart';

class VaccineMetricModel extends VaccineMetric {
  const VaccineMetricModel({
    required String babyId,
    required DateTime timeCreated,
    required DateTime startTime,
    required String Vaccine,
    required String series,
    required String notes,
  }) : super(
            babyId: babyId,
            timeCreated: timeCreated,
            startTime: startTime,
            Vaccine: Vaccine,
            series: series,
            notes: notes);

  factory VaccineMetricModel.fromJson(Map<String, dynamic> json) {
    return VaccineMetricModel(
      babyId: json['babyId'],
      timeCreated: json['timeCreated'],
      startTime: json['startTime'],
      Vaccine: json['Vaccine'],
       series: json['series'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'babyId': babyId,
        'timeCreated': timeCreated,
        'startTime': startTime,
        'series':  double.parse('0' + series),
        'Vaccine': Vaccine,
        'notes': notes
      };
}

class VaccineMetric extends Equatable {
  final String babyId;
  final DateTime timeCreated;
  final DateTime startTime;
  final String Vaccine;
  final String series;
  final String notes;

  const VaccineMetric({
    required this.babyId,
    required this.timeCreated,
    required this.startTime,
    required this.Vaccine,
    required this.series,
    required this.notes,
  });

  @override
  List<Object?> get props =>
      [babyId, timeCreated, startTime, Vaccine, series, notes];
}
