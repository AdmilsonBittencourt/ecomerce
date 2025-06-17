import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/cart_manager.dart';
import 'package:perfumes_ecomerce/models/address.dart';
import 'package:perfumes_ecomerce/order_manager.dart';
import 'package:provider/provider.dart';


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores do formulário (sem mudanças)
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _cityController = TextEditingController();
  // ... outros controladores ...

  String? _selectedPaymentMethod;
  bool _isProcessing = false; // NOVO: Estado para controlar o carregamento

  @override
  void dispose() {
    _streetController.dispose();
    _numberController.dispose();
    // ... dispose dos outros controladores ...
    super.dispose();
  }

  // --- MUDANÇA PRINCIPAL AQUI ---
  Future<void> _confirmOrder() async {
    if (!_formKey.currentState!.validate()) {
      return; // Se o formulário for inválido, não faz nada
    }
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma forma de pagamento.')),
      );
      return;
    }

    setState(() {
      _isProcessing = true; // Inicia o carregamento
    });

    final cartManager = Provider.of<CartManager>(context, listen: false);
    final orderManager = Provider.of<OrderManager>(context, listen: false);
    
    // 1. Cria o objeto Address a partir dos controladores
    final address = Address(
      street: _streetController.text,
      city: _cityController.text,
      zipCode: "12345-678", // Exemplo, use o seu _zipCodeController.text
      country: "Brasil", // Exemplo
    );

    // 2. Chama o método `addOrder` refatorado
    await orderManager.addOrder(
      items: cartManager.items,
      address: address, // Passa o objeto Address
      paymentMethod: _selectedPaymentMethod!,
      totalAmount: cartManager.totalPrice,
    );

    // 3. Atualiza o CartManager para refletir que o carrinho foi esvaziado
    // A chamada `clearCart` não é mais necessária aqui, pois o `createOrder` já faz isso.
    // Mas precisamos notificar o CartManager para atualizar a UI em outras telas.
    await cartManager.fetchCartItems();


    if (mounted) { // Verifica se o widget ainda está na árvore
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido Finalizado com Sucesso!')),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    }
    
    // O setState abaixo não é estritamente necessário se a tela vai ser fechada,
    // mas é uma boa prática para parar o carregamento caso a navegação falhe.
    // setState(() {
    //   _isProcessing = false; 
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finalizar Pedido')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ... Todos os seus TextFormFields de endereço (sem mudanças) ...
              
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  // ATUALIZADO: Desabilita o botão e mostra spinner durante o processamento
                  onPressed: _isProcessing ? null : _confirmOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  icon: _isProcessing
                      ? Container( // Spinner
                          width: 24,
                          height: 24,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Icon(Icons.check_circle_outline, color: Colors.white),
                  label: Text(
                    _isProcessing ? 'Processando...' : 'Confirmar Pedido',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}