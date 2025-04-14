class User {
  String? name;
  String? surname;
  String? email;
  String? birthday;
  int avgCycleLength; // average length of menstrual cycle
  int avgPeriodLength; // average length of period
  DateTime lastestCycleStart;

  User(
      {this.name,
      this.surname,
      this.email,
      this.birthday,
      this.avgCycleLength = 0,
      this.avgPeriodLength = 0,
      DateTime? lastestCycleStart})
      : lastestCycleStart = lastestCycleStart ?? DateTime(2025, 04, 07);

  void updateProfile({String? name, String? email, int? age}) {
    if (name != null) {
      this.name = name;
    }
    if (email != null) {
      this.email = email;
    }
    if (birthday != null) {
      this.birthday = birthday;
    }
  }

  void setAvgCycleLength(int cycleLength) {
    avgCycleLength = cycleLength;
  }

  void setAvgPeriodLength(int periodLength) {
    avgPeriodLength = periodLength;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'email': email,
      'birthday': birthday,
      'avgCycleLength': avgCycleLength,
      'avgPeriodLength': avgPeriodLength,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      surname: map['surname'],
      email: map['email'],
      birthday: map['birthday'],
      avgCycleLength: map['cycleLength'],
      avgPeriodLength: map['periodLength'],
    );
  }
}
