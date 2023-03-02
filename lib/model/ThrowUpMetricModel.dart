import 'package:equatable/equatable.dart';

class ThrowUpMetricModel extends ThrowUpMetric {
  const ThrowUpMetricModel({
    required String babyId,
    required DateTime timeCreated,
    required DateTime startTime,
    required String ThrowUpColor,
    required String Amount,
    required String notes,
  }) : super(
            babyId: babyId,
            timeCreated: timeCreated,
            startTime: startTime,
            ThrowUpColor: ThrowUpColor,
            Amount: Amount,
            notes: notes);

  factory ThrowUpMetricModel.fromJson(Map<String, dynamic> json) {
    return ThrowUpMetricModel(
      babyId: json['babyId'],
      timeCreated: json['timeCreated'],
      startTime: json['startTime'],
      ThrowUpColor: json['ThrowUpColor'],
      Amount: json['Amount'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'babyId': babyId,
        'timeCreated': timeCreated,
        'startTime': startTime,
        'Amount': Amount,
        'ThrowUpColor': ThrowUpColor,
        'notes': notes
      };
}

class ThrowUpMetric extends Equatable {
  final String babyId;
  final DateTime timeCreated;
  final DateTime startTime;
  final String ThrowUpColor;
  final String Amount;
  final String notes;

  const ThrowUpMetric({
    required this.babyId,
    required this.timeCreated,
    required this.startTime,
    required this.ThrowUpColor,
    required this.Amount,
    required this.notes,
  });

  @override
  List<Object?> get props =>
      [babyId, timeCreated, startTime, ThrowUpColor, Amount, notes];
}
