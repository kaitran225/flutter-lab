import 'dart:async';

// Async function: simulate loading a delivery order
Future<String> loadOrder() async {
  print('Loading order...');
  await Future.delayed(const Duration(seconds: 2));
  return 'Order loaded successfully!';
}

// Stream: emit delivery checkpoint numbers 1 to 5
Stream<int> deliverySteps() async* {
  for (int i = 1; i <= 5; i++) {
    await Future.delayed(const Duration(milliseconds: 500));
    yield i;
  }
}

Future<void> main() async {
  // Async / Await
  String result = await loadOrder();
  print(result);

  // Null safety
  String? customerName;
  print(customerName ?? 'Guest customer');

  String? deliveryAddress = '123 Green Street';
  print(deliveryAddress?.length);

  // ! asserts the value is not null
  String confirmedAddress = deliveryAddress!;
  print('Address: $confirmedAddress');

  // Stream
  print('Delivery progress:');
  await for (int step in deliverySteps()) {
    print('Checkpoint: $step');
  }
}
