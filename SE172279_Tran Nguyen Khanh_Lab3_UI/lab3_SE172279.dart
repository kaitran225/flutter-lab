// Lab 3 — Advanced Dart (async, stream, microtask, JSON, factory)
// Single file: 5 mini-projects. Run: dart run lab3.dart

import 'dart:async';

// ═══════════════════════════════════════════════════════════
// Bài 1 – Product Model & Repository (Future + Stream)
// ═══════════════════════════════════════════════════════════

class Product {
  final int id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});

  @override
  String toString() => 'Product(id: $id, name: $name, price: $price)';
}

class ProductRepository {
  // Broadcast: nhiều listener có thể lắng nghe cùng lúc
  final _controller = StreamController<Product>.broadcast();

  // Future: giả lập delay khi fetch từ server
  Future<List<Product>> getAll() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Product(id: 1, name: 'Laptop', price: 999.99),
      Product(id: 2, name: 'Phone', price: 499.99),
    ];
  }

  Stream<Product> liveAdded() => _controller.stream;

  void addProduct(Product product) {
    _controller.add(product);
  }

  void dispose() => _controller.close();
}

Future<void> runBai1() async {
  print('\n========== BÀI 1: Product Model & Repository ==========');
  final repo = ProductRepository();

  // Lắng nghe stream trước khi emit
  repo.liveAdded().listen((product) {
    print('Sản phẩm mới: $product');
  });

  final products = await repo.getAll();
  print('Danh sách sản phẩm:');
  products.forEach(print);

  repo.addProduct(Product(id: 3, name: 'Tablet', price: 299.99));
  repo.addProduct(Product(id: 4, name: 'Watch', price: 199.99));

  await Future.delayed(const Duration(milliseconds: 100));
  repo.dispose();
}

// ═══════════════════════════════════════════════════════════
// Bài 2 – User Repository with JSON
// ═══════════════════════════════════════════════════════════

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  // Factory: parse từ JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  @override
  String toString() => 'User(name: $name, email: $email)';
}

class UserRepository {
  // Giả lập JSON trả về từ API
  static const _fakeApiData = [
    {'name': 'Nguyễn Văn A', 'email': 'vana@fpt.edu.vn'},
    {'name': 'Trần Thị B', 'email': 'thib@fpt.edu.vn'},
    {'name': 'Lê Văn C', 'email': 'vanc@fpt.edu.vn'},
  ];

  Future<List<User>> fetchUsers() async {
    await Future.delayed(const Duration(seconds: 1));
    return _fakeApiData.map((json) => User.fromJson(json)).toList();
  }
}

Future<void> runBai2() async {
  print('\n========== BÀI 2: User Repository with JSON ==========');
  final repo = UserRepository();

  print('Đang tải dữ liệu người dùng...');
  final users = await repo.fetchUsers();

  print('Danh sách người dùng (${users.length} người):');
  for (final user in users) {
    print('  - $user');
  }
}

// ═══════════════════════════════════════════════════════════
// Bài 3 – Async + Microtask Debugging
// ═══════════════════════════════════════════════════════════

Future<void> runBai3() async {
  print('\n========== BÀI 3: Async + Microtask Debugging ==========');

  print('1  [SYNC]      Bắt đầu main()');

  // Future: vào EVENT QUEUE — chạy sau microtask
  Future(() {
    print('4  [EVENT]     Future(() {}) — event queue');
  });

  // scheduleMicrotask: vào MICROTASK QUEUE — chạy trước event
  scheduleMicrotask(() {
    print('3  [MICROTASK] scheduleMicrotask — microtask queue');
  });

  // Future.microtask: cũng là microtask queue
  Future.microtask(() {
    print('3b [MICROTASK] Future.microtask — cũng là microtask queue');
  });

  print('2  [SYNC]      Kết thúc main() (code đồng bộ)');

  /*
   * GIẢI THÍCH THỨ TỰ THỰC THI (Event Loop):
   * 1. Code đồng bộ (SYNC) chạy hết trước: print 1 rồi print 2.
   * 2. Sau khi main sync xong, Dart xử lý MICROTASK QUEUE trước
   *    (scheduleMicrotask + Future.microtask) → print 3, 3b.
   * 3. Cuối cùng mới tới EVENT QUEUE (Future(() {})) → print 4.
   * Vì vậy thứ tự: 1 → 2 → 3 → 3b → 4.
   */

  // Chờ event queue chạy xong trước khi sang bài tiếp
  await Future.delayed(const Duration(milliseconds: 50));
}

// ═══════════════════════════════════════════════════════════
// Bài 4 – Stream Transformation (map + where)
// ═══════════════════════════════════════════════════════════

Future<void> runBai4() async {
  print('\n========== BÀI 4: Stream Transformation ==========');
  print('Stream gốc: 1, 2, 3, 4, 5');
  print('─────────────────────────────────');

  final numberStream = Stream.fromIterable([1, 2, 3, 4, 5]);

  final transformedStream = numberStream
      .map((n) {
        final squared = n * n;
        print('  map()   : $n → $n² = $squared');
        return squared;
      })
      .where((n) {
        final isEven = n % 2 == 0;
        print('  where() : $n → chẵn? $isEven');
        return isEven;
      });

  print('\nKết quả sau khi lọc (bình phương chẵn):');

  await transformedStream.listen((value) {
    print('   Emit: $value');
  }).asFuture();

  print('\nChỉ 2² = 4 và 4² = 16 là số chẵn trong 1²..5²');
}

// ═══════════════════════════════════════════════════════════
// Bài 5 – Factory Constructors & Cache (Singleton)
// ═══════════════════════════════════════════════════════════

class Settings {
  // Cache instance duy nhất
  static Settings? _instance;

  String theme;
  String language;

  // Private constructor — bên ngoài không gọi trực tiếp được
  Settings._internal({
    this.theme = 'light',
    this.language = 'vi',
  });

  // Factory: trả về instance đã cache (singleton)
  factory Settings() {
    _instance ??= Settings._internal();
    return _instance!;
  }

  @override
  String toString() => 'Settings(theme: $theme, language: $language)';
}

void runBai5() {
  print('\n========== BÀI 5: Factory Constructors & Cache ==========');

  final settingsA = Settings();
  print('settingsA: $settingsA');

  settingsA.theme = 'dark';
  print('Đổi theme sang dark qua settingsA');

  final settingsB = Settings();
  print('settingsB: $settingsB');

  print('\n─────────────────────────────────────────');
  print('settingsA == settingsB  : ${settingsA == settingsB}');
  print('identical(a, b)         : ${identical(settingsA, settingsB)}');
  print('hashCode a = ${settingsA.hashCode}');
  print('hashCode b = ${settingsB.hashCode}');

  if (identical(settingsA, settingsB)) {
    print('\nSingleton xác nhận: cả hai là CÙNG một object!');
    print('  -> Thay đổi theme ở A ảnh hưởng đến B: ${settingsB.theme}');
  }
}

// ═══════════════════════════════════════════════════════════
// Entry point — chạy lần lượt 5 bài
// ═══════════════════════════════════════════════════════════

Future<void> main() async {
  print('Lab 3 - Advanced Dart');
  print('MSSV: Tran Nguyen Khanh - SE172279');
  await runBai1();
  await runBai2();
  await runBai3();
  await runBai4();
  runBai5();

  print('\n========== DONE: All 5 exercises finished ==========');
}
