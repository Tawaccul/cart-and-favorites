import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

import 'package:test_1/model/cart_model.dart';
import 'package:test_1/model/item_model.dart';

class DBHelper {
  static Database? _database;
static const String cartTable = 'cart';

    Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'cart.db');
    var db = await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    await db.execute(
      'CREATE TABLE favorites(id INTEGER PRIMARY KEY, name TEXT, unit TEXT, price INTEGER, image TEXT)');
  }
  // Add more upgrade steps as needed for future versions
}

 _onCreate(Database db, int version) async {
    await db.execute(createCartTable);
    await db.execute('DROP TABLE IF EXISTS favorites');
    await db.execute('''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY,
        name TEXT,
        unit TEXT,
        price INTEGER,
        image TEXT
      )
    ''');
  }



final String createCartTable = '''
  CREATE TABLE $cartTable (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    productId TEXT,
    productName TEXT,
    initialPrice REAL,
    productPrice REAL,
    quantity INTEGER,
    unitTag TEXT,
    image TEXT
  )
''';
    Future<Item> insertToFavorite(Item item) async {
    var dbClient = await database;
    await dbClient!.insert('favorites', item.toMap());
    return item;
  }

  Future<List<Item>> getFavoritesList() async {
  var dbClient = await database;
  final List<Map<String, dynamic>> queryResult = await dbClient!.query('favorites');
  return queryResult.map((result) => Item.fromJson(result)).toList();
}

  Future<int> removeFromFavorites(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  

  Future<int> deleteFavoriteItem(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Item>> getFavoriteId(int id) async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryIdResult =
        await dbClient!.query('favorites', where: 'id = ?', whereArgs: [id]);
    return queryIdResult.map((e) => Item.fromMap(e)).toList();
  }

  
  Future<Cart> insert(Cart cart) async {
    var dbClient = await database;
    await dbClient!.insert('cart', cart.toMap());
    return cart;
  }
  


  Future<List<Cart>> getCartList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('cart');
    return queryResult.map((result) => Cart.fromMap(result)).toList();
  }

  Future<int> deleteCartItem(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateQuantity(Cart cart) async {
    var dbClient = await database;
    return await dbClient!.update('cart', cart.quantityMap(),
        where: "productId = ?", whereArgs: [cart.productId]);
  }

  Future<List<Cart>> getCartId(int id) async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryIdResult =
        await dbClient!.query('cart', where: 'id = ?', whereArgs: [id]);
    return queryIdResult.map((e) => Cart.fromMap(e)).toList();
  }
}