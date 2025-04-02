class Symptom {

  String name;
  bool? isActive;

  Symptom({required this.name, this.isActive});

  setActive(bool isActive) {
    this.isActive = isActive;
  }

  getActive() {
    return isActive;
  }

  String getName(){
    return name;
  }
}