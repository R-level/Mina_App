import 'package:mina_app/data/model/symptom.dart';

class SymptomList {

  final List<Symptom> _symptoms = [];
SymptomList(){
_symptoms.add(new Symptom(name: "Headache"));
_symptoms.add(new Symptom(name: "Cramps"));
_symptoms.add(new Symptom(name: "Nausea"));
_symptoms.add(new Symptom(name: "Vomiting"));
_symptoms.add(new Symptom(name: "Mental Fatigue"));
_symptoms.add(new Symptom(name: "PMS"));
_symptoms.add(new Symptom(name: "Stress"));
_symptoms.add(new Symptom(name: "Sleepy"));
}

  get symptoms => _symptoms;

  @override
  String toString() {
   
    String s = '';
    for(Symptom symptom in _symptoms){
      if(symptom.getActive()){
        s += "${symptom.getName()} ,";
      }
    }
    return s;
  }
}