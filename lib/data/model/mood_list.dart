import 'package:mina_app/data/model/mood.dart';

class MoodList {

    final List<Mood> _moods = [];
    MoodList(){
      _moods.add(Mood(name: "happy"));
      _moods.add(Mood(name: "sad"));
      _moods.add(Mood(name: "ok"));
      _moods.add(Mood(name: "angry")); 
    }
    List<Mood> get moods => _moods;

   String toString() {
   
    String s = '';
    for(Mood mood in _moods){
      if(mood.getActive()){
        s += "${mood.getName()} ,";
      }
    }
    return s;
  }
}