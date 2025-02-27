// // services/db_service.dart
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../models/product.dart';

// class DBService {
//   static final DBService instance = DBService._init();
//   static Database? _database;

//   factory DBService() {
//     return instance;
//   }
//   DBService._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await initDB();
//     return _database!;
//   }

//   Future<Database> initDB() async {
//     final dbPath = await getDatabasesPath();
//     return openDatabase(join(dbPath, 'products.db'),
//         version: 1, onCreate: _createDB);
//   }

//   Future<void> _createDB(Database db, int version) async {
//     await db.execute(
//         'CREATE TABLE products (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, price REAL, image TEXT)');
//   }

//   Future<List<Product>> getProducts() async {
//     final db = await instance.database;
//     final result = await db.query('products');
//     return result.map((json) => Product.fromMap(json)).toList();
//   }

//   Future<void> insertProduct(Product product) async {
//     final db = await instance.database;
//     await db.insert('products', product.toMap());
//   }

//   Future<void> updateProduct(Product product) async {
//     final db = await instance.database;
//     await db.update('products', product.toMap(),
//         where: 'id = ?', whereArgs: [product.id]);
//   }

//   Future<void> deleteProduct(int id) async {
//     final db = await instance.database;
//     await db.delete('products', where: 'id = ?', whereArgs: [id]);
//   }

//   Future<List<Product>> searchProduct(String query) async {
//     final db = await instance.database;
//     final result = await db.rawQuery(
//         "SELECT * FROM products WHERE name LIKE ? OR description LIKE ? OR CAST(price AS TEXT) LIKE ? OR image LIKE ?",
//         ['%$query%', '%$query%', '%$query%', '%$query%']);
//     return result.map((json) => Product.fromMap(json)).toList();
//   }
// }

import 'package:hive/hive.dart';
import '../models/product.dart';

class DBService {
  static const String boxName = "productsBox";
  static DBService? _instance;

  DBService._internal();
  static DBService get instance {
    _instance ??= DBService._internal();
    return _instance!;
  }

  Future<void> initDB() async {
    await Hive.openBox<Product>(boxName);
  }

  Box<Product> get _box => Hive.box<Product>(boxName);

  List<Product> getProducts() {
    return _box.values.toList();
  }

  Future<void> insertProduct(Product product) async {
    await _box.add(product);
  }

  Future<void> updateProduct(int index, Product product) async {
    await _box.putAt(index, product);
  }

  Future<void> deleteProduct(int index) async {
    await _box.deleteAt(index);
  }

  List<Product> searchProducts(String query) {
    return _box.values.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase()) ||
          product.description.toLowerCase().contains(query.toLowerCase()) ||
          product.price.toString().contains(query);
    }).toList();
  }
}
