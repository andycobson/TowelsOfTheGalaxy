class PersistentUser {
  final String currentBabyName;
  final List<dynamic> userBabyNames;

  const PersistentUser({
    required this.currentBabyName,
    required this.userBabyNames,
  });

  static PersistentUser fromJson(Map<String, dynamic> json) => PersistentUser(
      currentBabyName: json['currentBabyName'],
      userBabyNames: json['userBabyNames']);

  Map<String, dynamic> toJson() =>
      {'currentBabyName': currentBabyName, 'userBabyNames': userBabyNames};
}
