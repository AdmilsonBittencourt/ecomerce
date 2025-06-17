import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/cart_manager.dart';
import 'package:perfumes_ecomerce/models/perfume.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Perfume perfume;

  const ProductDetailScreen({super.key, required this.perfume});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isAddingToCart = false; // NOVO: Estado para controlar o carregamento

  // A lógica de controle de quantidade está perfeita, sem mudanças
  void _incrementQuantity() => setState(() => _quantity++);
  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  /// NOVO: Método async para centralizar a lógica de adicionar ao carrinho.
  Future<void> _addToCart() async {
    // Não faz nada se já estiver adicionando
    if (_isAddingToCart) return;

    setState(() {
      _isAddingToCart = true; // Inicia o carregamento
    });

    try {
      final cartManager = Provider.of<CartManager>(context, listen: false);
      // Espera a operação do banco de dados terminar
      await cartManager.addItem(widget.perfume, _quantity);

      if (mounted) {
        final totalPrice = widget.perfume.price * _quantity;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${widget.perfume.name}" x $_quantity adicionado!'),
            backgroundColor: Colors.green[700],
          ),
        );
      }
    } finally {
      // Garante que o estado de carregamento seja desativado, mesmo se ocorrer um erro.
      if (mounted) {
        setState(() {
          _isAddingToCart = false; // Finaliza o carregamento
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // O layout do seu widget está excelente, vamos mantê-lo.
    // A única mudança será no botão "Adicionar".
    return Scaffold(
      appBar: AppBar(title: Text(widget.perfume.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ... (Imagem, Nome, Preço, Descrição - sem mudanças) ...
             Center(child: ClipRRect(child: Image.network(widget.perfume.imageUrl, height: 300, fit: BoxFit.cover))),
             const SizedBox(height: 24),
             Text(widget.perfume.name, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
             const SizedBox(height: 8),
             Text('R\$ ${widget.perfume.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20)),
             const SizedBox(height: 24),
             const Text('Descrição do perfume...', style: TextStyle(fontSize: 16)),
             const SizedBox(height: 48),

            // Layout do seletor de quantidade e botão
            Row(
              children: <Widget>[
                // --- Seletor de Quantidade (sem mudanças na lógica) ---
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: <Widget>[
                      IconButton(icon: const Icon(Icons.remove), onPressed: _decrementQuantity),
                      Text('$_quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(icon: const Icon(Icons.add), onPressed: _incrementQuantity),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // --- Botão Adicionar ao Carrinho (ATUALIZADO) ---
                Expanded(
                  child: ElevatedButton(
                    // ATUALIZADO: Chama o novo método e desabilita durante o carregamento
                    onPressed: _isAddingToCart ? null : _addToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // Estilo para quando o botão estiver desabilitado
                      disabledBackgroundColor: Colors.grey[700],
                    ),
                    child: _isAddingToCart
                        ? const SizedBox( // Mostra um spinner de carregamento
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text( // Mostra o texto normal
                            'Adicionar',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}