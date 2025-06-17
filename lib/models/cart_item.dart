import 'package:perfumes_ecomerce/models/perfume.dart';

class CartItem {
  final Perfume perfume;
  int quantity; // Não é final, pois a quantidade pode ser alterada

  CartItem({
    required this.perfume,
    required this.quantity,
  });

  // Método para obter o preço total deste item do carrinho
  double get totalPrice => perfume.price * quantity;
}