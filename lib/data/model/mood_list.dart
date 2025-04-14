import 'package:mina_app/data/model/mood.dart';

class MoodList {
  final List<Mood> _moods = [];
  MoodList() {
    _moods.add(Mood(name: "happy"));
    _moods.add(Mood(name: "sad"));
    _moods.add(Mood(name: "ok"));
    _moods.add(Mood(name: "angry"));
  }
  List<Mood> get moods => _moods;

  @override
  String toString() {
    String s = '';
    for (Mood mood in _moods) {
      if (mood.getActive()) {
        s += "${mood.getName()} ,";
      }
    }
    return s;
  }

// Generate a MoodList from a comma-separated string
  static MoodList fromString(String stringList) {
    MoodList moodList = MoodList();
    List<String> moodNames =
        stringList.toLowerCase().split(',').map((s) => s.trim()).toList();

    for (Mood mood in moodList.moods) {
      if (moodNames.contains(mood.getName().toLowerCase())) {
        mood.setActive(true);
      }
    }
    return moodList;
  }
}
