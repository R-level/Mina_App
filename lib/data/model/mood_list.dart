import 'package:equatable/equatable.dart';

class MoodList extends Equatable {
  final List<String> moods;

  const MoodList({this.moods = const []});

  static const List<String> predefinedMoods = [
    'Happy',
    'Sad',
    'Irritable',
    'Anxious',
    'Calm',
    'Energetic',
    'Tired',
    'Emotional',
    'Motivated',
    'Stressed',
    'Relaxed',
    'Angry',
    'Excited',
    'Disappointed',
    'Confused',
  ];

  @override
  List<Object?> get props => [moods];

  Map<String, dynamic> toMap() {
    return {
      'moods': moods,
    };
  }

  factory MoodList.fromMap(Map<String, dynamic> map) {
    return MoodList(
      moods: List<String>.from(map['moods'] ?? []),
    );
  }

  static MoodList fromString(String? moodsString) {
    if (moodsString == null) {
      return const MoodList();
    }
    return MoodList(moods: moodsString.split(','));
  }

  @override
  String toString() {
    return moods.join(',');
  }

  MoodList copyWith({List<String>? moods}) {
    return MoodList(
      moods: moods ?? this.moods,
    );
  }

  MoodList addMood(String mood) {
    if (!moods.contains(mood)) {
      return MoodList(moods: [...moods, mood]);
    }
    return this;
  }

  MoodList removeMood(String mood) {
    return MoodList(moods: moods.where((m) => m != mood).toList());
  }
}
