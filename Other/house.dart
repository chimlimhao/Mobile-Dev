class House {
  int stair = 1;
  Window window;
  Roof roof;
  Door door;

  House(this.stair, this.window, this.roof, this.door);

  void buildHouse() {
    if (stair > 1) {
      print("House has $stair stairs");
    } else {
      print("House has 1 stair");
    }
    print('$window');
    print('$roof');
    print('$door');
  }
}

class Window {
  final String location;
  final int number;
  final String color;
  final String type;

  Window(this.location, this.number, this.color, this.type);

  @override
  String toString() {
    return "There are $number window in this house and $color $type window is on $location side";
  }
}

class Roof {
  final String type;
  final String material;

  Roof(this.type, this.material);
  @override
  String toString() {
    return "$type roof made of $material";
  }
}

class Door {
  final String type;
  final String material;
  final String location;

  Door(this.type, this.material, this.location);

  @override
  String toString() {
    return "$type door made of $material is in the $location";
  }
}

main() {
  Window w1 = Window('left', 4, 'red', 'Sliders');
  Roof r1 = Roof('Hip', 'Clay Tile');
  Door d1 = Door('Three Panel', 'Wood', 'Center');

  House h1 = House(3, w1, r1, d1);

  h1.buildHouse();
}
