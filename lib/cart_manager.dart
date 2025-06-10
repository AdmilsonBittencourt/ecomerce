import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/models/perfume.dart';
import 'package:perfumes_ecomerce/models/cart_item.dart';

// Usa ChangeNotifier para notificar os widgets que dependem dele
class CartManager extends ChangeNotifier {
  final List<CartItem> _items = []; // Lista interna de itens no carrinho

  List<CartItem> get items => List.unmodifiable(_items); // Getter para acessar os itens (imutável)

  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      total += item.totalPrice;
    }
    return total;
  }

  int get itemCount => _items.length; // Número de itens distintos no carrinho

  // Adiciona um perfume ao carrinho
  void addItem(Perfume perfume, int quantity) {
    bool found = false;
    for (var item in _items) {
      if (item.perfume.name == perfume.name) { // Se o perfume já está no carrinho
        item.quantity += quantity; // Aumenta a quantidade
        found = true;
        break;
      }
    }
    if (!found) { // Se o perfume não está no carrinho, adiciona um novo item
      _items.add(CartItem(perfume: perfume, quantity: quantity));
    }
    notifyListeners(); // Notifica os ouvintes sobre a mudança
  }

  // Remove um item completamente do carrinho
  void removeItem(Perfume perfume) {
    _items.removeWhere((item) => item.perfume.name == perfume.name);
    notifyListeners();
  }

  // Aumenta a quantidade de um item
  void incrementItemQuantity(Perfume perfume) {
    for (var item in _items) {
      if (item.perfume.name == perfume.name) {
        item.quantity++;
        break;
      }
    }
    notifyListeners();
  }

  // Diminui a quantidade de um item
  void decrementItemQuantity(Perfume perfume) {
    for (var item in _items) {
      if (item.perfume.name == perfume.name) {
        if (item.quantity > 1) {
          item.quantity--;
        } else {
          // Se a quantidade chegar a 0, remove o item
          _items.remove(item);
        }
        break;
      }
    }
    notifyListeners();
  }

  // Limpa todos os itens do carrinho
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}