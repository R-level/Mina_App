
import 'package:flutter/material.dart';
import 'package:mina_app/model/mood.dart';

class MoodListModel extends ChangeNotifier {


  
    final List<Mood> _moods = [];
    

    //add a new mood
    void add(Mood mood) {
      _moods.add(mood);
      notifyListeners();
}
  //remove a mood
  void remove(Mood mood) {
    _moods.remove(mood);
    notifyListeners();
  }

}