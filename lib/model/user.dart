class User {
  String userId;
  String? name;
  String? email;
  int? age;
  int cycleLength = 0; // average length of menstrual cycle
  int periodLength = 0; // average length of period

  User(this.userId, {this.name, this.email, this.age, this.cycleLength = 0, this.periodLength = 0});

  String getUserId() => userId;

  void updateProfile({String? name, String? email, int? age}) {
    if (name != null) {
      this.name = name;
    }
    if (email != null) {
      this.email = email;
    }
    if (age != null) {
      this.age = age;
    }
  }

  void setCycleLength(int cycleLength) {
    this.cycleLength = cycleLength;
  }

  void setPeriodLength(int periodLength) {
    this.periodLength = periodLength;
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'age': age,
      'cycleLength': cycleLength,
      'periodLength': periodLength,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      map['userId'],
      name: map['name'],
      email: map['email'],
      age: map['age'],
      cycleLength: map['cycleLength'],
      periodLength: map['periodLength'],
    );
  }
}