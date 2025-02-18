

class Cycle {
  final String cycleId;
  final String userId;
  final int cycleLength;
  final int periodLength;

  Cycle({
    required this.userId,
    required this.cycleId,
    required this.cycleLength,
    required this.periodLength,
  });

  Map<String, dynamic> toMap() {
    return {
      'cycleId': cycleId,
      'userId': userId,
      'cycleLength': cycleLength,
      'periodLength': periodLength,
    };
  }

  factory Cycle.fromMap(Map<String, dynamic> map) {
    return Cycle(
      userId: map['User.userId'],
      cycleId: map['cycleId'],
      cycleLength : map['cycleLength'],
      periodLength : map['periodLength'],
    );
  }
}