import 'package:perfumes_ecomerce/models/cart_item.dart';

class Order {
  final String id; // Um ID único para o pedido
  final List<CartItem> items; // Itens que foram comprados
  final Map<String, dynamic> addressDetails; // Detalhes do endereço no momento do pedido
  final String paymentMethod; // Forma de pagamento
  final double totalAmount; // Valor total do pedido
  final DateTime orderDate; // Data e hora do pedido

  Order({
    required this.id,
    required this.items,
    required this.addressDetails,
    required this.paymentMethod,
    required this.totalAmount,
    required this.orderDate,
  });

  // Um getter opcional para o número total de produtos (frascos) no pedido
  int get totalProductsInOrder {
    int count = 0;
    for (var item in items) {
      count += item.quantity;
    }
    return count;
  }
}