import 'package:equatable/equatable.dart';

class TempMetricModel extends TempMetric {
  const TempMetricModel({
    required String babyId,
    required DateTime timeCreated,
    required DateTime tempTime,
    required String temperature,
    required String tempType,
    required String notes,
  }) : super(
          babyId: babyId,
          timeCreated: timeCreated,
          tempTime: tempTime,
          temperature: temperature,
          tempType: tempType,
          notes: notes,
        );

  factory TempMetricModel.fromJson(Map<String, dynamic> json) {
    return TempMetricModel(
      babyId: json['babyId'],
      timeCreated: json['timeCreated'],
      tempTime: json['tempTime'],
      temperature: json['temperature'],
      tempType: json['tempType'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'babyId': babyId,
        'timeCreated': timeCreated,
        'tempTime': tempTime,
        'temperature': double.parse('0' + temperature),
        'tempType': tempType,
        'notes': notes,
      };
}

class TempMetric extends Equatable {
  final String babyId;
  final DateTime timeCreated;
  final DateTime tempTime;
  final String temperature;
  final String tempType;
  final String notes;

  const TempMetric(
      {required this.babyId,
      required this.timeCreated,
      required this.tempTime,
      required this.temperature,
      required this.tempType,
      required this.notes});

  @override
  List<Object?> get props =>
      [babyId, timeCreated, tempTime, temperature, tempType, notes];
}
