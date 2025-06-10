import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/order_manager.dart'; // Importa o gerenciador de pedidos
import 'package:perfumes_ecomerce/models/order.dart'; // Importa o modelo Order
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Para formatar a data

// Adicione esta dependência ao seu pubspec.yaml se ainda não tiver:
// dependencies:
//   flutter:
//     sdk: flutter
//   intl: ^0.19.0 # ou a versão mais recente

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      body: Consumer<OrderManager>(
        builder: (context, orderManager, child) {
          if (orderManager.orders.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined, size: 100, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Você ainda não fez nenhum pedido.',
                    style: TextStyle(fontSize: 20, color: Colors.black54),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Comece a explorar nossos perfumes!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: orderManager.orders.length,
            itemBuilder: (context, index) {
              final order = orderManager.orders[index];
              // Formata a data para um formato legível
              final dateFormatter = DateFormat('dd/MM/yyyy HH:mm');
              final formattedDate = dateFormatter.format(order.orderDate);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Detalhes do Pedido ${order.id.substring(0, 8)} (em breve!)')),
                    );
                    // TODO: Navegar para uma tela de detalhes de pedido, passando o objeto order
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Pedido #${order.id.substring(0, 8).toUpperCase()}', // Mostra os primeiros 8 caracteres do ID
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Data: $formattedDate',
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Total: R\$ ${order.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Itens: ${order.totalProductsInOrder} produtos',
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        // Você pode adicionar mais detalhes aqui, como status do pedido etc.
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