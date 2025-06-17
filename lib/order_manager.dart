// lib/order_manager.dart

import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/models/order.dart';
import 'package:perfumes_ecomerce/models/cart_item.dart'; // <<< ESSA LINHA PRECISA ESTAR AQUI!
import 'package:uuid/uuid.dart';

class OrderManager extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  void addOrder({
    required List<CartItem> items, // <<< Verifique se é List<CartItem> aqui
    required Map<String, dynamic> addressDetails,
    required String paymentMethod,
    required double totalAmount,
  }) {
    const uuid = Uuid();
    final newId = uuid.v4();

    final newOrder = Order(
      id: newId,
      items: List.from(items), // Cria uma cópia da lista de CartItem
      addressDetails: addressDetails,
      paymentMethod: paymentMethod,
      totalAmount: totalAmount,
      orderDate: DateTime.now(),
    );

    _orders.insert(0, newOrder);
    notifyListeners();
  }
}