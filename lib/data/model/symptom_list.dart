import 'package:equatable/equatable.dart';

class SymptomList extends Equatable {
  final List<String> symptoms;

  const SymptomList({this.symptoms = const []});

  static const List<String> predefinedSymptoms = [
    'Cramps',
    'Headache',
    'Bloating',
    'Fatigue',
    'Breast Tenderness',
    'Back Pain',
    'Acne',
    'Nausea',
    'Dizziness',
    'Food Cravings',
    'Insomnia',
    'Muscle Pain'
  ];

  @override
  List<Object?> get props => [symptoms];

  Map<String, dynamic> toMap() {
    return {
      'symptoms': symptoms,
    };
  }

  factory SymptomList.fromMap(Map<String, dynamic> map) {
    return SymptomList(
      symptoms: List<String>.from(map['symptoms'] ?? []),
    );
  }

  static SymptomList fromString(String? symptomsString) {
    if (symptomsString == null || symptomsString.isEmpty) {
      return const SymptomList();
    }
    return SymptomList(symptoms: symptomsString.split(','));
  }

  @override
  String toString() {
    return symptoms.join(',');
  }

  SymptomList copyWith({List<String>? symptoms}) {
    return SymptomList(
      symptoms: symptoms ?? this.symptoms,
    );
  }

  SymptomList addSymptom(String symptom) {
    if (!symptoms.contains(symptom)) {
      return SymptomList(symptoms: [...symptoms, symptom]);
    }
    return this;
  }

  SymptomList removeSymptom(String symptom) {
    return SymptomList(symptoms: symptoms.where((s) => s != symptom).toList());
  }
}
