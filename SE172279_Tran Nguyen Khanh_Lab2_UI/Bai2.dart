void main() {
  // --- List ---
  List<int> cartQuantities = [7, 8, 9, 10, 8, 7];
  print('Cart quantities: $cartQuantities');

  // Add and remove items on the List
  cartQuantities.add(6);
  cartQuantities.remove(7);
  print('After editing: $cartQuantities');
  print('First quantity: ${cartQuantities[0]}');

  // --- Math operators ---
  int apples = 10;
  int oranges = 3;
  print('apples + oranges = ${apples + oranges}');
  print('apples - oranges = ${apples - oranges}');
  print('apples == oranges: ${apples == oranges}');
  print('apples > oranges && oranges > 0: ${apples > oranges && oranges > 0}');

  // Conditional operator
  String result = apples > oranges ? 'more apples' : 'more oranges';
  print(result);

  // Set
  Set<String> aisles = {'Dairy', 'Bakery', 'Produce', 'Dairy'};
  print('Aisles (Set): $aisles');
  aisles.add('Frozen');
  aisles.remove('Bakery');
  print('Set after update: $aisles');

  // Map
  Map<String, int> itemPrices = {'Milk': 9, 'Bread': 8, 'Eggs': 7};
  print('Milk price: ${itemPrices['Milk']}');
  itemPrices['Rice'] = 10;
  print('Price map: $itemPrices');

  // check null
  String? missingItem = null;
  print('Missing item: ${missingItem ?? 'Not found'}');
}