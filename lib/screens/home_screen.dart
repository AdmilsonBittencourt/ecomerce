import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/screens/welcome_screen.dart'; // Importa a tela de boas-vindas para o logout
import 'package:perfumes_ecomerce/models/perfume.dart'; // Importa nosso modelo de Perfume

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // Lista de perfumes de exemplo
  final List<Perfume> perfumes = [
    Perfume(
      name: 'Perfume Elegance',
      imageUrl: 'https://via.placeholder.com/150/A3B8B8/FFFFFF?text=Perfume1', // Imagem placeholder
      price: 199.99,
    ),
    Perfume(
      name: 'Essência Noturna',
      imageUrl: 'https://via.placeholder.com/150/8D9898/FFFFFF?text=Perfume2',
      price: 249.90,
    ),
    Perfume(
      name: 'Aroma da Primavera',
      imageUrl: 'https://via.placeholder.com/150/C6D8D8/000000?text=Perfume3',
      price: 150.00,
    ),
    Perfume(
      name: 'Toque Amadeirado',
      imageUrl: 'https://via.placeholder.com/150/667373/FFFFFF?text=Perfume4',
      price: 280.50,
    ),
    Perfume(
      name: 'Doce Tentação',
      imageUrl: 'https://via.placeholder.com/150/A7B8B8/FFFFFF?text=Perfume5',
      price: 175.25,
    ),
     Perfume(
      name: 'Mistério Oriental',
      imageUrl: 'https://via.placeholder.com/150/9F8B9B/FFFFFF?text=Perfume6',
      price: 320.00,
    ),
     Perfume(
      name: 'Frescor do Oceano',
      imageUrl: 'https://via.placeholder.com/150/B8D8D8/000000?text=Perfume7',
      price: 210.00,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfumaria Essência', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          // Ícone de Carrinho de Compras
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
            onPressed: () {
              // TODO: Navegar para a tela do carrinho
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Carrinho de compras (em breve!)')),
              );
            },
          ),
          // Ícone de Logout
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black87),
            onPressed: () {
              // Lógica de logout
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: perfumes.length, // O número de itens na lista é o tamanho da nossa lista de perfumes
        itemBuilder: (context, index) {
          final perfume = perfumes[index]; // Obtém o perfume atual pelo índice

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 2, // Uma pequena sombra para destacar o card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Bordas arredondadas
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: <Widget>[
                  // Imagem do Perfume
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      perfume.imageUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover, // Ajusta a imagem para cobrir o espaço
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.broken_image,
                          size: 90,
                          color: Colors.grey,
                        ); // Ícone de erro se a imagem não carregar
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Detalhes do Perfume (Nome e Preço)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          perfume.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'R\$ ${perfume.price.toStringAsFixed(2)}', // Formata o preço com 2 casas decimais
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Ícone de Adicionar ao Carrinho (futuro)
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart, color: Colors.black87),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('"${perfume.name}" adicionado ao carrinho! (em breve!)')),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}