import 'package:equatable/equatable.dart';

class TempMetricModel extends TempMetric {
  const TempMetricModel({
    required String babyId,
    required DateTime timeCreated,
    required DateTime TempTime,
    //required DateTime endTime,
    required String temperature,
    required String tempType,
    required String notes,
  }) : super(
          babyId: babyId,
          timeCreated: timeCreated,
          TempTime: TempTime,
     //     endTime: endTime,
          temperature: temperature,
          tempType: tempType,
          notes: notes,
        );

  factory TempMetricModel.fromJson(Map<String, dynamic> json) {
    return TempMetricModel(
      babyId: json['babyId'],
      timeCreated: json['timeCreated'],
      TempTime: json['TempTime'],
    //  endTime: json['endTime'],
      temperature: json['temperature'],
      tempType: json['tempType'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'babyId': babyId,
        'timeCreated': timeCreated,
        'TempTime': TempTime,
     //   'endTime': endTime,
        'temperature': double.parse('0' + temperature),
        'tempType': tempType,
        'notes': notes,
      };
}

class TempMetric extends Equatable {
  final String babyId;
  final DateTime timeCreated;
  final DateTime TempTime;
//  final DateTime endTime;
  final String temperature;
  final String tempType;
  final String notes;

  const TempMetric(
      {required this.babyId,
      required this.timeCreated,
      required this.TempTime,
    //  required this.endTime,
      required this.temperature,
      required this.tempType,
      required this.notes});

  @override
  List<Object?> get props =>
      [babyId, timeCreated,  TempTime,/**, endTime,*/ temperature, tempType, notes];
}
 
