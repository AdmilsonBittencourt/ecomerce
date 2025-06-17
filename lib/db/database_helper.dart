import 'dart:convert'; // Necessário para codificar/decodificar JSON
import 'package:crypto/crypto.dart';
import 'package:perfumes_ecomerce/models/address.dart';
import 'package:perfumes_ecomerce/models/cart_item.dart';
import 'package:perfumes_ecomerce/models/order.dart';
import 'package:perfumes_ecomerce/models/perfume.dart';
import 'package:perfumes_ecomerce/models/user.dart';
import 'package:perfumes_ecomerce/perfume_filter.dart';
import 'package:perfumes_ecomerce/screens/product_list.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Nomes das tabelas
  static const _perfumesTable = 'perfumes_table';
  static const _cartTable = 'cart_table';
  static const _ordersTable = 'orders_table';
  static const _orderItemsTable = 'order_items_table';
  static const _usersTable = 'users_table';
  
  static const _databaseName = "ecommerce_app.db";
  static const _databaseVersion = 1;

  // Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Abre o banco de dados e o cria se não existir
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Cria todas as tabelas
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_perfumesTable (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        price REAL NOT NULL,
        brand TEXT NOT NULL,
        gender TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $_cartTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId TEXT NOT NULL,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        imageUrl TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        FOREIGN KEY (productId) REFERENCES $_perfumesTable (id)
      )
    ''');
    
    await db.execute('''
      CREATE TABLE $_ordersTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        addressDetails TEXT NOT NULL, -- Armazenado como uma string JSON
        paymentMethod TEXT NOT NULL,
        totalAmount REAL NOT NULL,
        orderDate TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $_orderItemsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        orderId INTEGER NOT NULL,
        productId TEXT NOT NULL,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        quantity INTEGER NOT NULL,
        imageUrl TEXT NOT NULL,
        FOREIGN KEY (orderId) REFERENCES $_ordersTable (id),
        FOREIGN KEY (productId) REFERENCES $_perfumesTable (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE $_usersTable (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE, -- Email deve ser único
        address TEXT NOT NULL,
        hashedPassword TEXT NOT NULL -- Nova coluna para a senha
      )
    ''');

    // Após criar as tabelas, popula com dados iniciais
    await _seedPerfumes(db);
 
}


  // ===================================================================
  // MÉTODOS PARA PERFUMES
  // ===================================================================

  /// Insere dados iniciais de perfumes na tabela de perfumes.
  Future<void> _seedPerfumes(Database db) async {
    final perfumes = [
      Perfume(id: 'p1', name: 'Acqua di Giò', imageUrl: 'https://epocacosmeticos.vteximg.com.br/arquivos/ids/825787/acqua-di-gio-profundo-giorgio-armani-perfume-masculino-edp%20-1-.jpg.jpg?v=638799054797670000', price: 450.0, brand: 'Giorgio Armani', gender: 'Masculino'),
      Perfume(id: 'p2', name: 'Chanel No. 5', imageUrl: 'https://cdn.awsli.com.br/600x450/364/364776/produto/100101003/c5c7744215.jpg', price: 850.0, brand: 'Chanel', gender: 'Feminino'),
      Perfume(id: 'p3', name: 'CK One', imageUrl: 'https://cdn.awsli.com.br/600x1000/764/764220/produto/344117583ca665ffb2.jpg', price: 320.0, brand: 'Calvin Klein', gender: 'Unissex'),
    ];

    for (final perfume in perfumes) {
      await db.insert(_perfumesTable, perfume.toMap());
    }
  }

  /// Retorna a lista de todos os perfumes do catálogo.
  Future<List<Perfume>> getPerfumes({PerfumeFilters? filters, String? searchTerm}) async {
    final db = await instance.database;
    
    // Listas para construir a consulta dinâmica de forma segura
    List<String> whereClauses = [];
    List<dynamic> whereArgs = [];

    // Se houver filtros, construímos as cláusulas WHERE
    if (filters != null) {
      // 1. Filtro por Gênero
      if (filters.selectedGenders.isNotEmpty) {
        // Cria placeholders '?' para cada gênero selecionado
        final placeholders = List.generate(filters.selectedGenders.length, (_) => '?').join(',');
        whereClauses.add('gender IN ($placeholders)');
        whereArgs.addAll(filters.selectedGenders);
      }
      
      // 2. Filtro por Marca
      if (filters.selectedBrands.isNotEmpty) {
        final placeholders = List.generate(filters.selectedBrands.length, (_) => '?').join(',');
        whereClauses.add('brand IN ($placeholders)');
        whereArgs.addAll(filters.selectedBrands);
      }
      
      // 3. Filtro por Preço
      // Verificamos se a faixa de preço foi alterada dos valores padrão
      if (filters.priceRange.start > 0 || filters.priceRange.end < 500) { // Use o seu valor máximo aqui
          whereClauses.add('price BETWEEN ? AND ?');
          whereArgs.add(filters.priceRange.start);
          whereArgs.add(filters.priceRange.end);
      }
    }

    // NOVO: Lógica da busca por termo
    if (searchTerm != null && searchTerm.isNotEmpty) {
      // Usamos LIKE com '%' para buscar o termo em qualquer parte do nome
      whereClauses.add('name LIKE ?');
      whereArgs.add('%$searchTerm%');
    }

    // Monta a consulta final
    String? whereString = whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null;

    final List<Map<String, dynamic>> maps = await db.query(
      _perfumesTable,
      where: whereString,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
    );

    return List.generate(maps.length, (i) => Perfume.fromMap(maps[i]));
  }


  // ===================================================================
  // MÉTODOS PARA CARRINHO (CART) - (sem grandes mudanças)
  // ===================================================================

   Future<void> addItem(CartItem item) async {
    final db = await instance.database;
    
    final List<Map<String, dynamic>> existingItems = await db.query(
      _cartTable, // <-- ATUALIZADO
      where: 'productId = ?',
      whereArgs: [item.perfumeId],
    );

    if (existingItems.isNotEmpty) {
      int newQuantity = existingItems.first['quantity'] + item.quantity;
      await db.update(
        _cartTable, // <-- ATUALIZADO
        {'quantity': newQuantity},
        where: 'productId = ?',
        whereArgs: [item.perfumeId],
      );
    } else {
      await db.insert(_cartTable, item.toMap()); // <-- ATUALIZADO
    }
  }

  /// Retorna todos os itens do carrinho como uma lista de CartItem.
  Future<List<CartItem>> getCartItems() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(_cartTable, orderBy: 'name'); // <-- ATUALIZADO
    return List.generate(maps.length, (i) {
      return CartItem.fromMap(maps[i]);
    });
  }
  
  /// Atualiza a quantidade de um item específico pelo seu ID único no banco.
  Future<int> updateItemQuantity(int id, int quantity) async {
    final db = await instance.database;
    if (quantity <= 0) {
      // Se a quantidade for zero ou menos, remove o item
      return await removeItem(id);
    }
    return await db.update(
      _cartTable, // <-- ATUALIZADO
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Remove um item do carrinho pelo seu ID único no banco.
  Future<int> removeItem(int id) async {
    final db = await instance.database;
    return await db.delete(
      _cartTable, // <-- ATUALIZADO
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> clearCart() async { 
    final db = await instance.database; 
    return await db.delete(_cartTable); 
  }

  // (Vou omitir o código repetido do carrinho para manter a resposta concisa,
  // mas você deve mantê-lo aqui no seu arquivo, renomeando os métodos se preferir)


  // ===================================================================
  // MÉTODOS PARA PEDIDOS (ORDERS)
  // ===================================================================

  /// Cria um novo pedido, move os itens do carrinho para os itens do pedido e limpa o carrinho.
  /// Tudo isso dentro de uma transação para garantir a integridade dos dados.
  Future<void> createOrder(List<CartItem> items, Address address, String paymentMethod, double totalAmount) async {
    final db = await instance.database;

    await db.transaction((txn) async {
      // 1. Inserir o pedido na tabela de pedidos
      final orderData = {
        'addressDetails': jsonEncode(address.toMap()), // Converte o endereço para uma string JSON
        'paymentMethod': paymentMethod,
        'totalAmount': totalAmount,
        'orderDate': DateTime.now().toIso8601String(),
      };
      final orderId = await txn.insert(_ordersTable, orderData);

      // 2. Inserir cada item do carrinho na tabela de itens de pedido
      for (final item in items) {
        final orderItemData = {
          'orderId': orderId,
          'productId': item.perfumeId,
          'name': item.name,
          'price': item.price,
          'quantity': item.quantity,
          'imageUrl': item.imageUrl,
        };
        await txn.insert(_orderItemsTable, orderItemData);
      }
    });

    // 3. Limpar o carrinho após o pedido ser criado com sucesso
    await clearCart();
  }

  /// Retorna o histórico de todos os pedidos.
  Future<List<Order>> getOrders() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> orderMaps = await db.query(_ordersTable, orderBy: 'orderDate DESC');
    
    List<Order> orders = [];

    for (var orderMap in orderMaps) {
      // Para cada pedido, busca seus itens correspondentes
      final List<Map<String, dynamic>> itemMaps = await db.query(
        _orderItemsTable,
        where: 'orderId = ?',
        whereArgs: [orderMap['id']],
      );

      // Recria os objetos
      List<CartItem> items = itemMaps.map((itemMap) => CartItem(
        // Note que não temos o 'id' do carrinho aqui, o que está correto
        perfumeId: itemMap['productId'], 
        name: itemMap['name'], 
        price: itemMap['price'], 
        imageUrl: itemMap['imageUrl'], 
        quantity: itemMap['quantity']
      )).toList();
      
      Address address = Address.fromMap(jsonDecode(orderMap['addressDetails']));

      orders.add(Order(
        id: orderMap['id'].toString(), // Usando o ID do banco
        items: items, 
        addressDetails: address, 
        paymentMethod: orderMap['paymentMethod'], 
        totalAmount: orderMap['totalAmount'], 
        orderDate: DateTime.parse(orderMap['orderDate'])
      ));
    }

    return orders;
  }

  // user

//   Future<void> _seedUser(Database db) async {
//   // 1. Define uma senha padrão
//   final defaultPassword = '123456'; 

//   // 2. Cria o hash dessa senha
//   final hashedPassword = sha256.convert(utf8.encode(defaultPassword)).toString();

//   // 3. Cria o usuário passando o hash
//   final defaultUser = UserModel(
//     id: 1, // ID fixo
//     name: 'Nome do Usuário',
//     email: 'usuario@email.com',
//     address: 'Seu Endereço, 123',
//     hashedPassword: hashedPassword, // <-- CORREÇÃO AQUI
//   );
  
//   await db.insert(_usersTable, defaultUser.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace);
// }

  Future<UserModel?> registerUser(UserModel user) async {
    final db = await instance.database;
    try {
      final id = await db.insert(
        _usersTable,
        user.toMap(),
        // Garante que não haverá emails duplicados
        conflictAlgorithm: ConflictAlgorithm.fail, 
      );
      // Retorna o usuário com o ID correto (embora seja sempre 1 no nosso caso)
      return user; 
    } catch (e) {
      // Retorna nulo se o email já existir
      print('Erro ao registrar: $e');
      return null;
    }
  }

  /// Verifica as credenciais de login.
  Future<UserModel?> loginUser(String email, String password) async {
    final db = await instance.database;
    
    // 1. Busca o usuário pelo email
    final List<Map<String, dynamic>> maps = await db.query(
      _usersTable,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      final userMap = maps.first;
      final storedHash = userMap['hashedPassword'];

      // 2. Transforma a senha digitada em hash
      final providedPasswordHash = sha256.convert(utf8.encode(password)).toString();
      
      // 3. Compara os hashes
      if (storedHash == providedPasswordHash) {
        // Se as senhas baterem, retorna o objeto do usuário
        return UserModel.fromMap(userMap);
      }
    }
    
    // Retorna nulo se o usuário não for encontrado ou a senha estiver incorreta
    return null;
  }

  /// Busca os dados do usuário.
  Future<UserModel> getUser() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _usersTable,
      where: 'id = ?',
      whereArgs: [1], // Busca sempre pelo usuário de ID 1
    );
    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    // Fallback caso o seed não tenha funcionado
    return UserModel(id: 1, name: '', email: '', address: '', hashedPassword: '');
  }

  /// Atualiza os dados do usuário.
  Future<int> updateUser(UserModel user) async {
    final db = await instance.database;
    return await db.update(
      _usersTable,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [1], // Atualiza sempre o usuário de ID 1
    );
  }
}