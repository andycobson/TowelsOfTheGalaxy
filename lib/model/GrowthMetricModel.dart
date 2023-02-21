import 'package:equatable/equatable.dart';

class GrowthMetricModel extends GrowthMetric {
  const GrowthMetricModel({
    required String babyId,
    required DateTime timeCreated,
    required String height,
    required String weight,
    required String headCircumference,
    required String notes,
  }) : super(
          babyId: babyId,
          timeCreated: timeCreated,
          height: height,
          weight: weight,
          headCircumference: headCircumference,
          notes: notes,
        );

  factory GrowthMetricModel.fromJson(Map<String, dynamic> json) {
    return GrowthMetricModel(
      babyId: json['babyId'],
      timeCreated: json['timeCreated'],
      height: json['height'],
      weight: json['weight'],
      headCircumference: json['headCircumference'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'babyId': babyId,
        'timeCreated': timeCreated,
        'height': double.parse('0' + height),
        'weight': double.parse('0' + weight),
        'headCircumference': double.parse('0' + headCircumference),
        'notes': notes,
      };
}

class GrowthMetric extends Equatable {
  final String babyId;
  final DateTime timeCreated;

  final String height;
  final String weight;
  final String headCircumference;
  final String notes;

  const GrowthMetric({
    required this.babyId,
    required this.timeCreated,
    required this.height,
    required this.weight,
    required this.headCircumference,
    required this.notes,
  });

  @override
  List<Object?> get props =>
      [babyId, timeCreated, height, weight, headCircumference, notes];
}
