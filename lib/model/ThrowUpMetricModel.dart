import 'package:equatable/equatable.dart';

class ThrowUpMetricModel extends ThrowUpMetric {
  const ThrowUpMetricModel({
    required String babyId,
    required DateTime timeCreated,
    required DateTime startTime,
    required String throwUpColor,
    required String amount,
    required String notes,
  }) : super(
            babyId: babyId,
            timeCreated: timeCreated,
            startTime: startTime,
            throwUpColor: throwUpColor,
            amount: amount,
            notes: notes);

  factory ThrowUpMetricModel.fromJson(Map<String, dynamic> json) {
    return ThrowUpMetricModel(
      babyId: json['babyId'],
      timeCreated: json['timeCreated'],
      startTime: json['startTime'],
      throwUpColor: json['throwUpColor'],
      amount: json['amount'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'babyId': babyId,
        'timeCreated': timeCreated,
        'startTime': startTime,
        'amount': amount,
        'throwUpColor': throwUpColor,
        'notes': notes
      };
}

class ThrowUpMetric extends Equatable {
  final String babyId;
  final DateTime timeCreated;
  final DateTime startTime;
  final String throwUpColor;
  final String amount;
  final String notes;

  const ThrowUpMetric({
    required this.babyId,
    required this.timeCreated,
    required this.startTime,
    required this.throwUpColor,
    required this.amount,
    required this.notes,
  });

  @override
  List<Object?> get props =>
      [babyId, timeCreated, startTime, throwUpColor, amount, notes];
}
