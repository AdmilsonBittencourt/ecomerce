import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/db/database_helper.dart';
import 'package:perfumes_ecomerce/models/cart_item.dart';
import 'package:perfumes_ecomerce/models/perfume.dart';

class CartManager extends ChangeNotifier {
  List<CartItem> _items = []; // A lista agora é um cache dos dados do banco.
  bool isLoading = true;
  // Getters continuam úteis para a UI
  List<CartItem> get items => List.unmodifiable(_items);
  
  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get itemCount => _items.length;

  // Construtor: Ao iniciar o manager, busca os itens do carrinho
  CartManager() {
    fetchCartItems();
  }

  /// NOVO: Busca os itens do banco e atualiza o estado interno.
  Future<void> fetchCartItems() async {
    isLoading = true;
    _items = await DatabaseHelper.instance.getCartItems();
    isLoading = false;
    notifyListeners(); // Notifica a UI que a lista de itens foi atualizada
  }

  /// REFATORADO: Adiciona o item através do DatabaseHelper
  Future<void> addItem(Perfume perfume, int quantity) async {
    // Cria um CartItem baseado nos modelos que definimos
    final newItem = CartItem(
      perfumeId: perfume.id,
      name: perfume.name,
      price: perfume.price,
      imageUrl: perfume.imageUrl,
      quantity: quantity,
    );
    
    await DatabaseHelper.instance.addItem(newItem);
    await fetchCartItems(); // Após modificar o banco, busca a lista atualizada
  }

  /// REFATORADO: Remove o item pelo seu ID no banco
  Future<void> removeItem(int cartItemId) async {
    await DatabaseHelper.instance.removeItem(cartItemId);
    await fetchCartItems();
  }
  
  /// REFATORADO: Aumenta a quantidade
  Future<void> incrementItemQuantity(CartItem item) async {
    await DatabaseHelper.instance.updateItemQuantity(item.id!, item.quantity + 1);
    await fetchCartItems();
  }

  /// REFATORADO: Diminui a quantidade ou remove
  Future<void> decrementItemQuantity(CartItem item) async {
    if (item.quantity > 1) {
      await DatabaseHelper.instance.updateItemQuantity(item.id!, item.quantity - 1);
    } else {
      // Se a quantidade é 1, remover o item
      await DatabaseHelper.instance.removeItem(item.id!);
    }
    await fetchCartItems();
  }

  /// REFATORADO: Limpa o carrinho no banco de dados
  Future<void> clearCart() async {
    await DatabaseHelper.instance.clearCart();
    await fetchCartItems();
  }
}