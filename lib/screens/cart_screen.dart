import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/cart_manager.dart';
import 'package:perfumes_ecomerce/screens/checkout_screen.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Carrinho', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          // O Consumer aqui garante que o botão só aparece se o carrinho não estiver vazio
          Consumer<CartManager>(
            builder: (context, cartManager, child) {
              if (cartManager.items.isEmpty || cartManager.isLoading) {
                return const SizedBox.shrink(); // Não mostra nada se estiver vazio ou carregando
              }
              return child!;
            },
            child: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                // A lógica do showDialog permanece a mesma
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Limpar Carrinho?'),
                    content: const Text('Tem certeza que deseja remover todos os itens?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Limpar'),
                        onPressed: () {
                          // A chamada já é a correta, pois o método tem o mesmo nome
                          Provider.of<CartManager>(context, listen: false).clearCart();
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Consumer<CartManager>(
        builder: (context, cartManager, child) {
          // Usando o novo flag `isLoading`
          if (cartManager.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cartManager.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Seu carrinho está vazio!', style: TextStyle(fontSize: 20, color: Colors.black54)),
                ],
              ),
            );
          }
          
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: cartManager.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = cartManager.items[index];
                    return Card(
                      // ... O design do seu Card está perfeito, vamos manter ...
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: <Widget>[
                            // ... Imagem ...
                            // ... Nome e Preço ...
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text(cartItem.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                   const SizedBox(height: 4),
                                   Text('R\$ ${cartItem.price.toStringAsFixed(2)} / un.'),
                                   const SizedBox(height: 8),
                                  // --- MUDANÇA AQUI ---
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove, size: 20),
                                        onPressed: () {
                                          // ATUALIZADO: Passa o objeto cartItem inteiro
                                          cartManager.decrementItemQuantity(cartItem);
                                        },
                                      ),
                                      Text('${cartItem.quantity}', style: const TextStyle(fontSize: 16)),
                                      IconButton(
                                        icon: const Icon(Icons.add, size: 20),
                                        onPressed: () {
                                          // ATUALIZADO: Passa o objeto cartItem inteiro
                                          cartManager.incrementItemQuantity(cartItem);
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Column(
                               children: [
                                  Text('R\$ ${cartItem.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  // --- MUDANÇA AQUI ---
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      // ATUALIZADO: Passa o ID único do item no carrinho
                                      cartManager.removeItem(cartItem.id!);
                                    },
                                  ),
                               ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // --- O rodapé com o total e o botão de checkout permanecem iguais ---
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                   children: [
                      Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           const Text('Total do Carrinho:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                           Text('R\$ ${cartManager.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                         ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                         width: double.infinity,
                         child: ElevatedButton(
                           onPressed: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutScreen()));
                           },
                           style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                           ),
                           child: const Text('Finalizar Compra', style: TextStyle(color: Colors.white, fontSize: 18)),
                         ),
                      ),
                   ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}