import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 9 JSON & Local Storage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(),
        ),
      ),
      home: const MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Lab 9: JSON & Local Storage'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMenuButton(context, 'Lab 9.1: Read JSON from Assets', const Lab91Screen()),
          _buildMenuButton(context, 'Lab 9.2: Save & Load from Storage', const Lab92Screen()),
          _buildMenuButton(context, 'Lab 9.3: JSON CRUD Mini Database', const Lab93Screen()),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, Widget target) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(Icons.data_object, color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => target)),
      ),
    );
  }
}

// --- Lab 9.1: Read JSON From Assets ---
class Lab91Screen extends StatefulWidget {
  const Lab91Screen({super.key});

  @override
  State<Lab91Screen> createState() => _Lab91ScreenState();
}

class _Lab91ScreenState extends State<Lab91Screen> {
  List<dynamic> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssetJson();
  }

  Future<void> _loadAssetJson() async {
    try {
      final String response = await rootBundle.loadString('assets/data/items.json');
      final data = await json.decode(response);
      setState(() {
        _items = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading asset JSON: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 9.1: Assets JSON')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(item['id'].toString()),
                    ),
                    title: Text(
                      item['name'] ?? 'No Name',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(item['description'] ?? 'No Description'),
                  ),
                );
              },
            ),
    );
  }
}

// --- Lab 9.2: Save & Load From Device Storage ---
class Lab92Screen extends StatefulWidget {
  const Lab92Screen({super.key});

  @override
  State<Lab92Screen> createState() => _Lab92ScreenState();
}

class _Lab92ScreenState extends State<Lab92Screen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/items_9_2_SE172279.json');
  }

  Future<void> _loadItems() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonData = json.decode(contents);
        setState(() {
          _items = jsonData.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      debugPrint("Error loading items: $e");
    }
  }

  Future<void> _saveItems() async {
    final file = await _localFile;
    await file.writeAsString(json.encode(_items));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved to storage!')),
      );
    }
  }

  void _addItem() {
    if (_nameController.text.isNotEmpty) {
      setState(() {
        _items.add({
          'id': DateTime.now().millisecondsSinceEpoch,
          'name': _nameController.text,
          'description': _descController.text,
        });
      });
      _nameController.clear();
      _descController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9.2: Local Storage'),
        actions: [
          IconButton(onPressed: _saveItems, icon: const Icon(Icons.save)),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
                TextField(controller: _descController, decoration: const InputDecoration(labelText: 'Description')),
                const SizedBox(height: 10),
                ElevatedButton(onPressed: _addItem, child: const Text('Add Item')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ListTile(
                  title: Text(item['name'] ?? ''),
                  subtitle: Text(item['description'] ?? ''),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- Lab 9.3: JSON CRUD Mini Database ---
class Lab93Screen extends StatefulWidget {
  const Lab93Screen({super.key});

  @override
  State<Lab93Screen> createState() => _Lab93ScreenState();
}

class _Lab93ScreenState extends State<Lab93Screen> {
  List<Map<String, dynamic>> _allItems = [];
  List<Map<String, dynamic>> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/database_9_3_SE172279.json');
  }

  Future<void> _loadData() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonData = json.decode(contents);
        setState(() {
          _allItems = jsonData.cast<Map<String, dynamic>>();
          _filteredItems = _allItems;
        });
      }
    } catch (e) {
      debugPrint("Error loading database: $e");
    }
  }

  Future<void> _saveData() async {
    final file = await _localFile;
    await file.writeAsString(json.encode(_allItems));
  }

  void _onSearchChanged() {
    setState(() {
      _filteredItems = _allItems
          .where((item) =>
              item['name'].toString().toLowerCase().contains(_searchController.text.toLowerCase()) ||
              item['description'].toString().toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _showItemDialog([Map<String, dynamic>? item]) {
    final nameController = TextEditingController(text: item?['name'] ?? '');
    final descController = TextEditingController(text: item?['description'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item == null ? 'Add Item' : 'Edit Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  if (item == null) {
                    // Add
                    _allItems.add({
                      'id': DateTime.now().millisecondsSinceEpoch,
                      'name': nameController.text,
                      'description': descController.text,
                    });
                  } else {
                    // Edit
                    final index = _allItems.indexWhere((element) => element['id'] == item['id']);
                    if (index != -1) {
                      _allItems[index] = {
                        'id': item['id'],
                        'name': nameController.text,
                        'description': descController.text,
                      };
                    }
                  }
                  _onSearchChanged();
                });
                _saveData();
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteItem(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() {
                _allItems.removeWhere((element) => element['id'] == id);
                _onSearchChanged();
              });
              _saveData();
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 9.3: CRUD Database')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text(item['description']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => _showItemDialog(item)),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteItem(item['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showItemDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
