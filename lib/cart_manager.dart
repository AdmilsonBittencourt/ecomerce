import 'package:flutter/foundation.dart';
import 'package:perfumes_ecomerce/database/database_helper.dart';
import 'package:perfumes_ecomerce/models/cart_item.dart';

// Usa ChangeNotifier para notificar os widgets que dependem dele
class CartManager extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<CartItem> _items = [];
  int _currentUserId = 1; // TODO: Get this from user authentication

  List<CartItem> get items => _items;
  int get itemCount => _items.length;

  double get totalPrice {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  Future<void> loadCartItems() async {
    final items = await _dbHelper.getUserCartItems(_currentUserId);
    _items = items.map((map) => CartItem.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addItem({
    required int productId,
    required String productName,
    required String productImageUrl,
    required double productPrice,
  }) async {
    final existingItemIndex = _items.indexWhere((item) => item.productId == productId);

    if (existingItemIndex >= 0) {
      await incrementItemQuantity(productId);
    } else {
      final cartItem = CartItem(
        userId: _currentUserId,
        productId: productId,
        productName: productName,
        productImageUrl: productImageUrl,
        productPrice: productPrice,
        quantity: 1,
      );

      final id = await _dbHelper.insertCartItem(cartItem.toMap());
      _items.add(CartItem(
        id: id,
        userId: _currentUserId,
        productId: productId,
        productName: productName,
        productImageUrl: productImageUrl,
        productPrice: productPrice,
        quantity: 1,
      ));
      notifyListeners();
    }
  }

  Future<void> incrementItemQuantity(int productId) async {
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      final item = _items[index];
      final newQuantity = item.quantity + 1;
      
      await _dbHelper.updateCartItemQuantity(item.id!, newQuantity);
      
      _items[index] = CartItem(
        id: item.id,
        userId: item.userId,
        productId: item.productId,
        productName: item.productName,
        productImageUrl: item.productImageUrl,
        productPrice: item.productPrice,
        quantity: newQuantity,
        createdAt: item.createdAt,
      );
      notifyListeners();
    }
  }

  Future<void> decrementItemQuantity(int productId) async {
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      final item = _items[index];
      if (item.quantity > 1) {
        final newQuantity = item.quantity - 1;
        
        await _dbHelper.updateCartItemQuantity(item.id!, newQuantity);
        
        _items[index] = CartItem(
          id: item.id,
          userId: item.userId,
          productId: item.productId,
          productName: item.productName,
          productImageUrl: item.productImageUrl,
          productPrice: item.productPrice,
          quantity: newQuantity,
          createdAt: item.createdAt,
        );
        notifyListeners();
      } else {
        await removeItem(productId);
      }
    }
  }

  Future<void> removeItem(int productId) async {
    final index = _items.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      final item = _items[index];
      await _dbHelper.deleteCartItem(item.id!);
      _items.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> clearCart() async {
    await _dbHelper.clearUserCart(_currentUserId);
    _items.clear();
    notifyListeners();
  }
}