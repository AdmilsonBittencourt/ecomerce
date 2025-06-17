import 'package:perfumes_ecomerce/models/address.dart';
import 'package:perfumes_ecomerce/models/cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final Address addressDetails; // <-- MUDOU: Agora usa a classe Address
  final String paymentMethod;
  final double totalAmount;
  final DateTime orderDate;

  Order({
    required this.id,
    required this.items,
    required this.addressDetails, // <-- MUDOU
    required this.paymentMethod,
    required this.totalAmount,
    required this.orderDate,
  });

  // Getter refatorado para ser mais conciso
  int get totalProductsInOrder => items.fold(0, (sum, item) => sum + item.quantity);

  // Método para converter o pedido em JSON (para enviar para a API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toMap()).toList(), // Converte cada item
      'addressDetails': addressDetails.toMap(), // Usa o toMap do Address
      'paymentMethod': paymentMethod,
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(), // Padrão recomendado para datas
    };
  }

  // Método para criar um pedido a partir de um JSON (recebido da API)
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List)
          .map((itemJson) => CartItem.fromMap(itemJson))
          .toList(),
      addressDetails: Address.fromMap(json['addressDetails']),
      paymentMethod: json['paymentMethod'],
      totalAmount: json['totalAmount'],
      orderDate: DateTime.parse(json['orderDate']),
    );
  }
}