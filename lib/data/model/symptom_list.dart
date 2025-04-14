import 'package:mina_app/data/model/symptom.dart';

class SymptomList {
  final List<Symptom> _symptoms = [];
  SymptomList() {
    _symptoms.add(Symptom(name: "Headache"));
    _symptoms.add(Symptom(name: "Cramps"));
    _symptoms.add(Symptom(name: "Nausea"));
    _symptoms.add(Symptom(name: "Vomiting"));
    _symptoms.add(Symptom(name: "Mental Fatigue"));
    _symptoms.add(Symptom(name: "PMS"));
    _symptoms.add(Symptom(name: "Stress"));
    _symptoms.add(Symptom(name: "Sleepy"));
  }

  List<Symptom> get symptoms => _symptoms;

  @override
  String toString() {
    String s = '';
    for (Symptom symptom in _symptoms) {
      if (symptom.getActive()) {
        s += "${symptom.getName()} ,";
      }
    }
    return s;
  }

  static SymptomList fromString(String stringList) {
    SymptomList symptomList = SymptomList();

    List<String> symptomNames =
        stringList.toLowerCase().split(',').map((s) => s.trim()).toList();
    for (Symptom symptom in symptomList.symptoms) {
      if (symptomNames.contains(symptom.getName().toLowerCase())) {
        symptom.setActive(true);
      }
    }
    return symptomList;
  }
}
