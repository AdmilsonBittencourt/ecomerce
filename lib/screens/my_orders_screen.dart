import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/order_manager.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
// Garanta que está importando o modelo correto

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      body: Consumer<OrderManager>(
        builder: (context, orderManager, child) {
          // 1. PRIMEIRO, verificamos se está carregando
          if (orderManager.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. DEPOIS, verificamos se a lista está vazia
          if (orderManager.orders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined, size: 100, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Você ainda não fez nenhum pedido.', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          // 3. Se não está carregando e não está vazia, mostramos a lista
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: orderManager.orders.length,
            itemBuilder: (context, index) {
              final order = orderManager.orders[index];
              final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(order.orderDate);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: InkWell(
                  onTap: () {
                    // TODO: Navegar para uma tela de detalhes do pedido.
                    // Ex: Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailPage(order: order)));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Detalhes do Pedido #${order.id}')),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Pedido #${order.id}', // O ID agora é um int, então convertemos para string
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Data: $formattedDate'),
                        const SizedBox(height: 4),
                        Text('Itens: ${order.totalProductsInOrder} produtos'),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Total: R\$ ${order.totalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}