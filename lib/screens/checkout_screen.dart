import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/cart_manager.dart';
import 'package:provider/provider.dart';
import 'package:perfumes_ecomerce/order_manager.dart';
import 'package:perfumes_ecomerce/models/address.dart';
import 'package:perfumes_ecomerce/database/database_helper.dart';
import 'package:perfumes_ecomerce/auth/auth_manager.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _databaseHelper = DatabaseHelper();
  bool _isLoading = true;
  List<Address> _savedAddresses = [];
  Address? _selectedAddress;
  bool _useNewAddress = false;

  
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _complementController = TextEditingController();

  
  String? _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    _loadSavedAddresses();
  }

  Future<void> _loadSavedAddresses() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final authManager = Provider.of<AuthManager>(context, listen: false);
      final currentUser = authManager.currentUser;

      if (currentUser != null) {
        final addresses = await _databaseHelper.getUserAddresses(currentUser.id!);
        setState(() {
          _savedAddresses = addresses.map((map) => Address.fromMap(map)).toList();
          if (_savedAddresses.isNotEmpty) {
            _selectedAddress = _savedAddresses.first;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _selectAddress(Address address) {
    setState(() {
      _selectedAddress = address;
      _useNewAddress = false;
    });
  }

  void _useNewAddressForm() {
    setState(() {
      _useNewAddress = true;
      _selectedAddress = null;
    });
  }

  @override
  void dispose() {
    _streetController.dispose();
    _numberController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _complementController.dispose();
    super.dispose();
  }

  Future<void> _confirmOrder() async {
    if (_selectedAddress == null && !_useNewAddress) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione ou cadastre um endereço.')),
      );
      return;
    }

    if (_useNewAddress && !_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma forma de pagamento.')),
      );
      return;
    }

    final cartManager = Provider.of<CartManager>(context, listen: false);
    final orderManager = Provider.of<OrderManager>(context, listen: false);
    final orderTotal = cartManager.totalPrice;

    Map<String, dynamic> addressDetails;
    if (_useNewAddress) {
      addressDetails = {
        'street': _streetController.text,
        'number': _numberController.text,
        'neighborhood': _neighborhoodController.text,
        'complement': _complementController.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'zip_code': _zipCodeController.text,
      };
    } else {
      addressDetails = {
        'street': _selectedAddress!.street,
        'number': _selectedAddress!.number,
        'neighborhood': _selectedAddress!.neighborhood,
        'complement': _selectedAddress!.complement,
        'city': _selectedAddress!.city,
        'state': _selectedAddress!.state,
        'zip_code': _selectedAddress!.zipCode,
      };
    }

    try {
      await orderManager.addOrder(
        items: cartManager.items,
        addressDetails: addressDetails,
        paymentMethod: _selectedPaymentMethod!,
        totalAmount: orderTotal,
      );

      cartManager.clearCart();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pedido Finalizado com Sucesso!')),
      );

      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e, stack) {
      print('Erro ao salvar pedido: $e');
      print(stack);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar o pedido: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartManager = Provider.of<CartManager>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Pedido',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF800020),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    
                    const Text(
                      'Endereço de Entrega',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    
                    if (_savedAddresses.isNotEmpty) ...[
                      const Text(
                        'Endereços Salvos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._savedAddresses.map((address) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: RadioListTile<Address>(
                          title: Text(
                            '${address.street}, ${address.number}${address.complement?.isNotEmpty == true ? ' - ${address.complement}' : ''}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          subtitle: Text(
                            '${address.neighborhood}, ${address.city} - ${address.state}\nCEP: ${address.zipCode}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          value: address,
                          groupValue: _selectedAddress,
                          onChanged: (value) => _selectAddress(value!),
                        ),
                      )),
                      const SizedBox(height: 16),
                    ],

                    
                    if (!_useNewAddress)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _useNewAddressForm,
                          icon: const Icon(Icons.add_location_alt_outlined),
                          label: const Text('Usar Novo Endereço'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),

                    
                    if (_useNewAddress) ...[
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
                            return 'O CEP deve ter 8 dígitos.';
                          }
                          return null;
                        },
                      ),
                    ],
                    const SizedBox(height: 32),

                    
                    const Text(
                      'Forma de Pagamento',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
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
