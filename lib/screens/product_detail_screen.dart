import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/models/perfume.dart';
import 'package:perfumes_ecomerce/cart_manager.dart'; // Importa o gerenciador
import 'package:provider/provider.dart'; // Importa o provider

class ProductDetailScreen extends StatefulWidget {
  final Perfume perfume;

  const ProductDetailScreen({super.key, required this.perfume});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1; // Variável de estado para a quantidade, inicializada com 1

  double get _totalPrice => widget.perfume.price * _quantity; // Getter para o preço total

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_quantity > 1) { // Garante que a quantidade mínima seja 1
        _quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.perfume.name, style: const TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Imagem do Perfume (maior)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  widget.perfume.imageUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 300,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Nome do Perfume
            Text(
              widget.perfume.name,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Preço por Unidade (mantido para informação)
            Text(
              'R\$ ${widget.perfume.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20, // Tamanho um pouco menor para o preço unitário
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),

            // Descrição do Perfume
            const Text(
              'Este perfume exclusivo combina notas cítricas frescas com um coração floral delicado e um fundo amadeirado e almiscarado.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 48),

            // Novo layout: Seletor de Quantidade e Botão Adicionar ao Carrinho
            Row(
              children: <Widget>[
                // Seletor de Quantidade (lado esquerdo)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), // Padding interno
                  decoration: BoxDecoration(
                    color: Colors.grey[100], // Fundo cinza claro
                    borderRadius: BorderRadius.circular(10), // Bordas arredondadas
                    border: Border.all(color: Colors.grey[300]!), // Borda suave
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Ocupa apenas o espaço necessário
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.remove, color: Colors.black54, size: 20),
                        onPressed: _decrementQuantity,
                        padding: EdgeInsets.zero, // Remove padding padrão do IconButton
                        constraints: const BoxConstraints(), // Remove constraints para ajuste fino
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.black54, size: 20),
                        onPressed: _incrementQuantity,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16), // Espaçamento entre o seletor e o botão

                // Botão Adicionar ao Carrinho (lado direito, expandido)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Acessa a instância do CartManager e adiciona o item
                      Provider.of<CartManager>(context, listen: false)
                        .addItem(widget.perfume, _quantity);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('"${widget.perfume.name}" x $_quantity (Total: R\$ ${_totalPrice.toStringAsFixed(2)}) adicionado!')),
                      );
                      // TODO: Adicionar lógica para adicionar ao carrinho com a quantidade e preço total
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Fundo preto como na imagem
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 25),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espaça texto e preço
                      children: <Widget>[
                        const Text(
                          'Adicionar',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'R\$ ${_totalPrice.toStringAsFixed(2)}', // Preço total dinâmico
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
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