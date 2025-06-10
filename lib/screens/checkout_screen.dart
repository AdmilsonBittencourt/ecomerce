import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/cart_manager.dart';
import 'package:provider/provider.dart';
import 'package:perfumes_ecomerce/order_manager.dart'; // Importa o gerenciador de pedidos

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey =
      GlobalKey<FormState>(); // Chave para o formulário para validação

  // Controladores para os campos de endereço
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _complementController =
      TextEditingController(); // Complemento opcional

  // Variável para a forma de pagamento selecionada
  String? _selectedPaymentMethod;

  @override
  void dispose() {
    // Libera os controladores quando a tela é descartada
    _streetController.dispose();
    _numberController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _complementController.dispose();
    super.dispose();
  }

  void _confirmOrder() {
    if (_formKey.currentState!.validate()) {
      if (_selectedPaymentMethod == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, selecione uma forma de pagamento.')),
        );
        return;
      }

      final cartManager = Provider.of<CartManager>(context, listen: false);
      final orderManager = Provider.of<OrderManager>(context, listen: false); // <<< Obter OrderManager
      final orderTotal = cartManager.totalPrice;

      // Chama o addOrder do OrderManager, passando os CartItems diretamente
      orderManager.addOrder(
        items: cartManager.items, // <<< Passe os itens do carrinho diretamente!
        addressDetails: {
          'street': _streetController.text,
          'number': _numberController.text,
          'neighborhood': _neighborhoodController.text,
          'complement': _complementController.text,
          'city': _cityController.text,
          'state': _stateController.text,
          'zipCode': _zipCodeController.text,
        },
        paymentMethod: _selectedPaymentMethod!,
        totalAmount: orderTotal,
      );

      cartManager.clearCart();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido Finalizado com Sucesso!')),
      );

      // (Remova o print do orderDetails, pois não estamos mais gerando aquele Map aqui)
      // print('Detalhes do Pedido: $orderDetails'); // Esta linha pode ser removida ou ajustada

      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }


  @override
  Widget build(BuildContext context) {
    final cartManager =
        Provider.of<CartManager>(context); // Para exibir o total

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Pedido',
            style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Associa a chave ao formulário
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Seção de Endereço
              const Text(
                'Endereço de Entrega',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(
                  labelText: 'Rua',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe a rua.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _numberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Número',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.format_list_numbered),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o número.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _complementController,
                      decoration: const InputDecoration(
                        labelText: 'Complemento (opcional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.add_location_alt_outlined),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _neighborhoodController,
                decoration: const InputDecoration(
                  labelText: 'Bairro',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.map_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o bairro.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'Cidade',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_city_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, informe a cidade.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      decoration: const InputDecoration(
                        labelText: 'Estado (UF)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.flag_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o estado.';
                        }
                        if (value.length != 2) {
                          return 'Use 2 letras (Ex: SP).';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _zipCodeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'CEP',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_post_office_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe o CEP.';
                  }
                  if (value.length != 8) {
                    // Ex: 12345678 (sem hífen)
                    return 'O CEP deve ter 8 dígitos.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Seção de Forma de Pagamento
              const Text(
                'Forma de Pagamento',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              // Opção de Cartão de Crédito
              RadioListTile<String>(
                title: const Text('Cartão de Crédito'),
                value: 'credit_card',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                },
              ),
              // Opção de Boleto Bancário
              RadioListTile<String>(
                title: const Text('Boleto Bancário'),
                value: 'bank_slip',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Resumo do Pedido e Botão Confirmar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total a Pagar:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    Text(
                      'R\$ ${cartManager.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _confirmOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text(
                    'Confirmar Pedido',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
