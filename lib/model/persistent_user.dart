class PersistentUser {
  late String currentBabyName = "";
  late String userId;
  late List<dynamic> userBabyNames;

  static final PersistentUser instance = PersistentUser._internal();

  PersistentUser._internal();

  factory PersistentUser(
      String currentBabyName, String userId, List<dynamic> userBabyNames) {
    instance.currentBabyName = currentBabyName;
    instance.userBabyNames = userBabyNames;
    instance.userId = userId;
    return instance;
  }

  // static PersistentUser fromJson(Map<String, dynamic> json) => PersistentUser(
  //     currentBabyName: json['currentBabyName'],
  //     userBabyNames: json['userBabyNames']);

  Map<String, dynamic> toJson() =>
      {'currentBabyName': currentBabyName, 'userBabyNames': userBabyNames};

  @override
  String toString() {
    return "{PersistentUser: {currentBabyName: $currentBabyName, \nuserId: $userId, \nuserbabyNames: $userBabyNames\n}\n}";
  }
}
