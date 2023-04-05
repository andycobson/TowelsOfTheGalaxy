import 'package:equatable/equatable.dart';

class BabyModel extends BabyMetric {
  const BabyModel(
      {required String babyName,
      required String dateOfBirth,
      required String userId,
      required String gender})
      : super(
            babyName: babyName,
            dateOfBirth: dateOfBirth,
            userId: userId,
            gender: gender);

  factory BabyModel.fromJson(Map<String, dynamic> json) {
    return BabyModel(
        babyName: json['babyName'],
        dateOfBirth: json['dateOfBirth'],
        userId: json['userId'],
        gender: json['gender']);
  }

  Map<String, dynamic> toJson() => {
        'babyName': babyName,
        'dateOfBirth': dateOfBirth,
        'userId': userId,
        'gender': gender
      };
}

class BabyMetric extends Equatable {
  final String babyName;
  final String dateOfBirth;
  final String userId;
  final String gender;

  const BabyMetric(
      {required this.babyName,
      required this.dateOfBirth,
      required this.userId,
      required this.gender});

  @override
  List<Object?> get props => [babyName, dateOfBirth, userId, gender];
}
