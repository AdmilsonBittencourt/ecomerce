import 'package:perfumes_ecomerce/models/cart_item.dart';

class Order {
  final int? id;
  final int userId;
  final int addressId;
  final double totalAmount;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;
  final List<OrderItem> items;

  Order({
    this.id,
    required this.userId,
    required this.addressId,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    DateTime? createdAt,
    required this.items,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'address_id': addressId,
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, List<OrderItem> items) {
    return Order(
      id: map['id'],
      userId: map['user_id'],
      addressId: map['address_id'],
      totalAmount: map['total_amount'],
      paymentMethod: map['payment_method'],
      status: map['status'],
      createdAt: DateTime.parse(map['created_at']),
      items: items,
    );
  }

  
  int get totalProductsInOrder {
    int count = 0;
    for (var item in items) {
      count += item.quantity;
    }
    return count;
  }
}

class OrderItem {
  final int? id;
  final int orderId;
  final int productId;
  final int quantity;
  final double unitPrice;
  final DateTime createdAt;

  OrderItem({
    this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'],
      orderId: map['order_id'],
      productId: map['product_id'],
      quantity: map['quantity'],
      unitPrice: map['unit_price'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}