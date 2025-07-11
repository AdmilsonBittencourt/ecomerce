// lib/order_manager.dart

import 'package:flutter/foundation.dart';
import 'package:perfumes_ecomerce/database/database_helper.dart';
import 'package:perfumes_ecomerce/models/order.dart';
import 'package:perfumes_ecomerce/models/cart_item.dart'; 
import 'package:uuid/uuid.dart';

class OrderManager extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Order> _orders = [];
  int _currentUserId;

  OrderManager(this._currentUserId);

  List<Order> get orders => _orders;

  Future<void> loadUserOrders() async {
    final orders = await _dbHelper.getUserOrders(_currentUserId);
    _orders = await Future.wait(orders.map((orderMap) async {
      final orderItems = await _dbHelper.getOrderItems(orderMap['id']);
      return Order.fromMap(orderMap, orderItems.map((item) => OrderItem.fromMap(item)).toList());
    }));
    notifyListeners();
  }

  Future<void> addOrder({
    required List<CartItem> items,
    required Map<String, dynamic> addressDetails,
    required String paymentMethod,
    required double totalAmount,
  }) async {
    
    final addressId = await _dbHelper.insertAddress({
      ...addressDetails,
      'user_id': _currentUserId,
    });

    
    final orderId = await _dbHelper.insertOrder({
      'user_id': _currentUserId,
      'address_id': addressId,
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'status': 'pending',
    });

    
    for (var item in items) {
      await _dbHelper.insertOrderItem({
        'order_id': orderId,
        'product_id': item.productId,
        'quantity': item.quantity,
        'unit_price': item.productPrice,
      });
    }

    
    await loadUserOrders();
  }

  Future<void> updateOrderStatus(int orderId, String newStatus) async {
    await _dbHelper.updateOrderStatus(orderId, newStatus);
    await loadUserOrders();
  }

  void updateUserId(int userId) {
    _currentUserId = userId;
    loadUserOrders();
  }
}