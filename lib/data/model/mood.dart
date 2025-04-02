class Mood {

  String name;
  bool? isActive;

  Mood({required this.name, this.isActive});

  setActive(bool isActive) {
    this.isActive = isActive;
  }

  getActive() {
    return isActive;
  }

  getName(){
    return name;
  }

}