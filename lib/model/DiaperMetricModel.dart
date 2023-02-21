import 'package:equatable/equatable.dart';

class DiaperMetricModel extends DiaperMetric {
  const DiaperMetricModel({
    required String babyId,
    required DateTime timeCreated,
    required DateTime startTime,
    required String diaperContents,
    required String notes,
  }) : super(
            babyId: babyId,
            timeCreated: timeCreated,
            startTime: startTime,
            diaperContents: diaperContents,
            notes: notes);

  factory DiaperMetricModel.fromJson(Map<String, dynamic> json) {
    return DiaperMetricModel(
      babyId: json['babyId'],
      timeCreated: json['timeCreated'],
      startTime: json['startTime'],
      diaperContents: json['diaperContents'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'babyId': babyId,
        'timeCreated': timeCreated,
        'startTime': startTime,
        'diaperContents': diaperContents,
        'notes': notes
      };
}

class DiaperMetric extends Equatable {
  final String babyId;
  final DateTime timeCreated;
  final DateTime startTime;
  final String diaperContents;
  final String notes;

  const DiaperMetric({
    required this.babyId,
    required this.timeCreated,
    required this.startTime,
    required this.diaperContents,
    required this.notes,
  });

  @override
  List<Object?> get props =>
      [babyId, timeCreated, startTime, diaperContents, notes];
}
