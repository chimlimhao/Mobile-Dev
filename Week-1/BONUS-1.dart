enum Direction { north, east, south, west }

void main() {
  // Initial position {7, 3} and facing north
  int x = 7;
  int y = 3;
  Direction direction = Direction.north;

  // Example instruction sequence
  const instructions = "RAALAL";
  var instructionList = instructions.split('');
  // Process the instructions and get the final position and direction

  for (var instruction in instructionList) {
    // print(instruction);
    if (instruction == "R") {
      if (direction == Direction.north) {
        direction = Direction.east;
      } else if (direction == Direction.east) {
        direction = Direction.south;
      } else if (direction == Direction.south) {
        direction = Direction.west;
      } else if (direction == Direction.west) {
        direction = Direction.north;
      }
      print('instruction: $instruction');
      print('-> x: $x');
      print('-> y: $y');
      print('-> direction: $direction');
    } else if (instruction == "A") {
      if (direction == Direction.north) {
        y++;
      } else if (direction == Direction.east) {
        x++;
      } else if (direction == Direction.south) {
        y--;
      } else if (direction == Direction.west) {
        x--;
      }
      print('instruction: $instruction');
      print('-> x: $x');
      print('-> y: $y');
      print('-> direction: $direction');
    } else if (instruction == "L") {
      if (direction == Direction.north) {
        direction = Direction.west;
      } else if (direction == Direction.west) {
        direction = Direction.south;
      } else if (direction == Direction.south) {
        direction = Direction.east;
      } else if (direction == Direction.east) {
        direction = Direction.north;
      }
      print('instruction: $instruction');
      print('-> x: $x');
      print('-> y: $y');
      print('-> direction: $direction');
    }
  }
  print("Final position: ($x, $y)");
  print("Facing: $direction");
}
