enum RoofType { Gable, Gambrel, Flat, Hip }

enum WindowType { Sliding, Casement, Hopper, Fixed }

enum DoorType { One_Panel, Two_Panel, Three_Panel, Four_Panel }

enum FloorNumber { One, Two }

enum ChimneyType { Rounded, Square }

enum Color { Red, Yellow, Black, White }

enum HouseType { Cottage, Duplex }

class Window {
  Window type;
  int numWindows;
  String position;
  Color? color;

  Window(this.type, this.numWindows, this.position, this.color);
}

class Chimney {
  ChimneyType type;

  Chimney(this.type);
}

class Roof {
  RoofType type;
  Color? color;

  Roof(this.type, this.color);
}

class Door {
  DoorType type;
  int numDoors;
  String position;
  Color? color;

  Door(this.type, this.numDoors, this.position, this.color);
}

class Floor {
  Floor numFloors;

  Floor(this.numFloors);
}

class House {
  String address;
  HouseType? type;
  List<Roof> roofs = [];
  List<Door> doors = [];
  List<Window> windows = [];
  List<Floor> floors = [];
  List<Chimney> chimneys = [];

  House(this.address);

  void addRoof(Roof newRoof) {
    roofs.add(newRoof);
  }

  void addDoor(Door newDoor) {
    doors.add(newDoor);
  }

  void addWindow(Window newWindow) {
    windows.add(newWindow);
  }

  void addFloor(Floor newFloor) {
    floors.add(newFloor);
  }

  void addChimney(Chimney newChimney) {
    chimneys.add(newChimney);
  }

  @override
  String toString() {
    return 'House Type: ${type}';
  }

  void printHouse() {}
}

void main() {
  House h = House("123 Main Street");

  h.printHouse();
}
