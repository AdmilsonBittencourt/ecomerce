import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/db/database_helper.dart';
import 'package:perfumes_ecomerce/models/address.dart';
import 'package:perfumes_ecomerce/models/cart_item.dart';
import 'package:perfumes_ecomerce/models/order.dart';

class OrderManager extends ChangeNotifier {
  List<Order> _orders = [];
  bool isLoading = true;
  List<Order> get orders => List.unmodifiable(_orders);

  // Construtor: Carrega os pedidos salvos ao iniciar
  OrderManager() {
    fetchOrders();
  }

  /// NOVO: Busca os pedidos do banco e atualiza o estado
  Future<void> fetchOrders() async {
    isLoading = true;
    _orders = await DatabaseHelper.instance.getOrders();

    isLoading = false;
    notifyListeners();
  }
  
  /// REFATORADO: Cria um pedido usando o DatabaseHelper
  Future<void> addOrder({
    required List<CartItem> items,
    required Address address, // Usando nosso modelo Address
    required String paymentMethod,
    required double totalAmount,
  }) async {
    // A lógica de criar o pedido foi movida para o DatabaseHelper
    await DatabaseHelper.instance.createOrder(
      items,
      address,
      paymentMethod,
      totalAmount,
    );

    // O método createOrder no DatabaseHelper já limpa o carrinho.
    
    // Após criar o novo pedido, buscamos a lista atualizada de pedidos.
    await fetchOrders();
  }
}