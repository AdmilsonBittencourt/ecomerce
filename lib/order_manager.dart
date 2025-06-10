import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/models/order.dart';
import 'package:perfumes_ecomerce/models/perfume.dart';
import 'package:uuid/uuid.dart'; // Para gerar IDs únicos para os pedidos
import 'package:perfumes_ecomerce/models/cart_item.dart'; // Make sure this line is present

// Adicione esta dependência ao seu pubspec.yaml se ainda não tiver:
// dependencies:
//   flutter:
//     sdk: flutter
//   uuid: ^4.3.3 # ou a versão mais recente

class OrderManager extends ChangeNotifier {
  final List<Order> _orders = []; // Lista interna de pedidos

  List<Order> get orders => List.unmodifiable(_orders); // Getter para acessar os pedidos

  // Adiciona um novo pedido à lista
  void addOrder({
    required List<dynamic> items, // Recebe uma lista de Map<String, dynamic> ou CartItem
    required Map<String, dynamic> addressDetails,
    required String paymentMethod,
    required double totalAmount,
  }) {
    // Para simplificar, vou assumir que 'items' aqui é uma lista de Maps,
    // como coletado na CheckoutScreen. Em um cenário real, você poderia
    // converter para CartItem se necessário.
    // Ou, melhor ainda, a CheckoutScreen passaria uma List<CartItem> diretamente.

    // Vamos reconstruir os CartItems a partir da lista de maps (se for o caso)
    // Para simplicidade, vou assumir que o CartManager passa a lista original de CartItem
    // ou que a CheckoutScreen cria uma lista de cópias.

    // No exemplo, o CheckoutScreen já está passando um Map detalhado.
    // Para o Order, vou usar a lista de Map<String, dynamic> como está.
    // Se quiser que seja List<CartItem>, precisaríamos de mais lógica aqui ou na CheckoutScreen.

    // Gerando um ID único para o pedido
    const uuid = Uuid();
    final newId = uuid.v4(); // Gera um UUID versão 4

    final newOrder = Order(
      id: newId,
      items: items.map((itemMap) => CartItem( // Converte de volta para CartItem
        perfume: itemMap['perfumeName'] != null ? Perfume(
          name: itemMap['perfumeName'],
          imageUrl: '', // Imagem não está no map de item do pedido do checkout, ajustar se precisar
          price: itemMap['pricePerUnit'],
        ) : Perfume(name: 'Produto Desconhecido', imageUrl: '', price: 0.0), // Fallback
        quantity: itemMap['quantity'],
      )).toList(),
      addressDetails: addressDetails,
      paymentMethod: paymentMethod,
      totalAmount: totalAmount,
      orderDate: DateTime.now(), // Data e hora atual do pedido
    );

    _orders.insert(0, newOrder); // Adiciona o novo pedido no início da lista (mais recente primeiro)
    notifyListeners(); // Notifica os ouvintes sobre a mudança
  }

  // Você pode adicionar métodos para buscar um pedido específico, etc.
}