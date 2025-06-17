import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:perfumes_ecomerce/models/user.dart';
import 'package:perfumes_ecomerce/models/address.dart';
import 'package:perfumes_ecomerce/models/order.dart';
import 'package:perfumes_ecomerce/models/cart_item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'perfumes_ecommerce.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela de Usuários
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phone TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        password TEXT NOT NULL
      )
    ''');

    // Tabela de Endereços
    await db.execute('''
      CREATE TABLE addresses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        street TEXT NOT NULL,
        number TEXT NOT NULL,
        complement TEXT,
        neighborhood TEXT NOT NULL,
        city TEXT NOT NULL,
        state TEXT NOT NULL,
        zip_code TEXT NOT NULL,
        is_default BOOLEAN DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Tabela de Pedidos
    await db.execute('''
      CREATE TABLE orders(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        address_id INTEGER,
        total_amount REAL NOT NULL,
        payment_method TEXT NOT NULL,
        status TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id),
        FOREIGN KEY (address_id) REFERENCES addresses (id)
      )
    ''');

    // Tabela de Itens do Pedido
    await db.execute('''
      CREATE TABLE order_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER,
        product_id INTEGER,
        quantity INTEGER NOT NULL,
        unit_price REAL NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (order_id) REFERENCES orders (id)
      )
    ''');

    // Tabela do Carrinho
    await db.execute('''
      CREATE TABLE cart_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        product_id INTEGER,
        product_name TEXT NOT NULL,
        product_image_url TEXT NOT NULL,
        product_price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');
  }

  // Métodos para Usuários
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUser(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isEmpty) {
      return null;
    }

    return User.fromMap(maps.first);
  }

  // Métodos para Endereços
  Future<int> insertAddress(Map<String, dynamic> address) async {
    Database db = await database;
    return await db.insert('addresses', address);
  }

  Future<List<Map<String, dynamic>>> getUserAddresses(int userId) async {
    Database db = await database;
    return await db.query(
      'addresses',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  // Métodos para Pedidos
  Future<int> insertOrder(Map<String, dynamic> order) async {
    Database db = await database;
    return await db.insert('orders', order);
  }

  Future<int> insertOrderItem(Map<String, dynamic> orderItem) async {
    Database db = await database;
    return await db.insert('order_items', orderItem);
  }

  Future<List<Map<String, dynamic>>> getUserOrders(int userId) async {
    Database db = await database;
    return await db.query(
      'orders',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getOrderItems(int orderId) async {
    Database db = await database;
    return await db.query(
      'order_items',
      where: 'order_id = ?',
      whereArgs: [orderId],
    );
  }

  Future<int> updateOrderStatus(int orderId, String newStatus) async {
    Database db = await database;
    return await db.update(
      'orders',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }

  // Métodos para Carrinho
  Future<int> insertCartItem(Map<String, dynamic> cartItem) async {
    Database db = await database;
    return await db.insert('cart_items', cartItem);
  }

  Future<List<Map<String, dynamic>>> getUserCartItems(int userId) async {
    Database db = await database;
    return await db.query(
      'cart_items',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<int> updateCartItemQuantity(int id, int quantity) async {
    Database db = await database;
    return await db.update(
      'cart_items',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCartItem(int id) async {
    Database db = await database;
    return await db.delete(
      'cart_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> clearUserCart(int userId) async {
    Database db = await database;
    return await db.delete(
      'cart_items',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
} 