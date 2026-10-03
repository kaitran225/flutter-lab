// Rate a cafe drink by customer score
String rateDrink(int score) {
  if (score >= 9) {
    return 'Excellent';
  } else if (score >= 7) {
    return 'Good';
  } else if (score >= 5) {
    return 'Average';
  }
  return 'Poor';
}

// Arrow function: cups needed for a party
int cupsNeeded(int guests) => guests * guests;

void main() {
  // if/else
  int score = 8;
  print('Drink rating: ${rateDrink(score)}');

  // switch case — cafe shift day
  int day = 3;
  switch (day) {
    case 1:
      print('Sunday');
      break;
    case 2:
      print('Monday');
      break;
    case 3:
      print('Tuesday');
      break;
    case 4:
      print('Wednesday');
      break;
    case 5:
      print('Thursday');
      break;
    case 6:
      print('Friday');
      break;
    case 7:
      print('Saturday');
      break;
    default:
      print('Other day');
  }

  // for loop
  for (int i = 1; i <= 3; i++) {
    print('for: brew batch $i');
  }

  // for-in
  List<String> drinks = ['Espresso', 'Latte', 'Matcha'];
  for (String drink in drinks) {
    print('for-in: $drink');
  }

  // forEach
  drinks.forEach((drink) => print('forEach: $drink'));

  // Arrow function
  print('Cups for 3 guests = ${cupsNeeded(3)}');
}
