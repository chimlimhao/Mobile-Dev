void main() {
  // Map of pizza prices
  const pizzaPrices = {
    'margherita': 5.5,
    'pepperoni': 7.5,
    'vegetarian': 6.5,
  };

  // Example order
  const order = ['margherita', 'pepperoni', 'pineapple'];

  // Your code
  var total = 0.0;
  var totalPrice;
  var pizza;
  for (pizza in order) {
    // print(pizza);
    if (pizzaPrices.containsKey(pizza)) {
      // print(pizzaPrices[pizza]);
      var price = pizzaPrices[pizza];
      total += price as double;
    } else {
      print('$pizza is not in the menu');
    }
  }
  totalPrice = total.toStringAsFixed(0);
  print('Total: \$$totalPrice');
}
