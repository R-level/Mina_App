

class Cycle {
  final String cycleId;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;

  Cycle({
    required this.userId,
    required this.cycleId,
    required this.startDate,
    required this.endDate,
  
  });

  Map<String, dynamic> toMap() {
    return {
      'cycleId': cycleId,
      'userId': userId,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory Cycle.fromMap(Map<String, dynamic> map) {
    return Cycle(
      userId: map['User.userId'],
      cycleId: map['cycleId'],
      startDate : map['cycleLength'],
      endDate : map['periodLength'],
    );
  }

  get getCycleId => cycleId;
}