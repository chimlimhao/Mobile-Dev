class Window {
  int width_cm;
  int height_cm;
  int numWindows;
  String type;
  int? color;

  Window(this.width_cm, this.height_cm, this.color, this.type, this.numWindows);
}

class Door {
  int width_cm;
  int height_cm;
  int numDoors;
  String type;
  int? color;

  Door(this.width_cm, this.height_cm, this.color, this.type, this.numDoors);
}

class Chimney {
  int numChimneys;
  String type;

  Chimney(this.numChimneys, this.type);
}

class Roof {
  String type;
  int? color;

  Roof(this.type, this.color);
}

class House {
  String address;
  List<String> type = [];
  List<Window> windows = [];
  List<Door> doors = [];
  List<Chimney> chimneys = [];
  List<Roof> roofs = [];

  House(this.address, this.type);

  void addWindow(Window newWindow) {
    this.windows.add(newWindow);
  }

  void addDoor(Door newDoor) {
    this.doors.add(newDoor);
  }

  void addChimney(Chimney newChimney) {
    this.chimneys.add(newChimney);
  }

  void addRoof(Roof newRoof) {
    this.roofs.add(newRoof);
  }

  void printHouse() {
    if (windows.any((window) =>
        window.type == "Sliding" &&
        doors.any((door) =>
            door.type == "Two-Panel" &&
            chimneys.any((chimney) =>
                chimney.type == "Round" &&
                roofs.any((roof) => roof.type == "Sloped"))))) {
      print('House type: ${type[0]}');
    } else if (windows.any((window) =>
        window.type == "Casement" &&
        doors.any((door) =>
            door.type == "Four-Panel" &&
            chimneys.any((chimney) =>
                chimney.type == "Square" &&
                roofs.any((roof) => roof.type == "Sloped"))))) {
      print('House type: ${type[1]}');
    }
  }
}

void main() {
  House house = House("123 Main St", ["Cottage", "Duplex"]);

  // Cottage type of house
  Window window1 = Window(100, 100, 0x000000, "Sliding", 2);
  Door door1 = Door(100, 200, 0xffffff, "Two-Panel", 1);
  Chimney chimney1 = Chimney(2, "Round");
  Roof roof1 = Roof("Sloped", 0xc5c5c5);

  // Duplex type of house
  // Window window2 = Window(250, 100, 0x000000, "Casement", 4);
  // Door door2 = Door(100, 200, 0xffffff, "Four-Panel", 1);
  // Chimney chimney2 = Chimney(1, "Square");
  // Roof roof2 = Roof("Sloped", 0xffffff);

  house.addWindow(window1);
  house.addDoor(door1);
  house.addChimney(chimney1);
  house.addRoof(roof1);

  // house.addWindow(window2);
  // house.addDoor(door2);
  // house.addChimney(chimney2);
  // house.addRoof(roof2);

  house.printHouse();
}
