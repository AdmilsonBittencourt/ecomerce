import 'package:perfumes_ecomerce/models/perfume.dart';

class CartItem {
  final int? id;
  final int userId;
  final int productId;
  final String productName;
  final String productImageUrl;
  final double productPrice;
  final int quantity;
  final DateTime createdAt;

  CartItem({
    this.id,
    required this.userId,
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.productPrice,
    required this.quantity,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  double get totalPrice => productPrice * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'product_name': productName,
      'product_image_url': productImageUrl,
      'product_price': productPrice,
      'quantity': quantity,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      userId: map['user_id'],
      productId: map['product_id'],
      productName: map['product_name'],
      productImageUrl: map['product_image_url'],
      productPrice: map['product_price'],
      quantity: map['quantity'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}