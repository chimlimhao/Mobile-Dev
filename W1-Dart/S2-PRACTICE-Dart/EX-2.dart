void main() {
  // 1 - iLike
  const iLike = 'I like pizza';

  // 2 - toppings
  var toppings = 'with tomatoes';
  toppings += " and cheese";

  // 3 - message
  final message = '$iLike $toppings';
  print(message);

  // 4 - rbgColors
  const rbgColors = ['red', 'blue', 'green'];
  print(rbgColors);

  // 5 - weekDays
  var weekDays = ['monday', 'tuesday', 'wednesday'];
  weekDays.add('thursday');
  print(weekDays);

  // 6 - scores
  var scores = [45, 35, 50];
  scores = [45, 35, 50, 78];
  print(scores);
}
