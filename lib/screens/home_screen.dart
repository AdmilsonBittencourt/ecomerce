import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/screens/welcome_screen.dart'; // Importa a tela de boas-vindas para o logout
import 'package:perfumes_ecomerce/models/perfume.dart'; // Importa nosso modelo de Perfume

// A Home Screen agora será um StatefulWidget para gerenciar o estado da pesquisa
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista original de perfumes (constante)
  final List<Perfume> _allPerfumes = [
    Perfume(
      name: 'Perfume Elegance',
      imageUrl: 'https://via.placeholder.com/150/A3B8B8/FFFFFF?text=Perfume1',
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

  // Lista de perfumes que será exibida (filtrada pela pesquisa)
  List<Perfume> _foundPerfumes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _foundPerfumes = _allPerfumes; // Inicialmente, mostra todos os perfumes
    _searchController.addListener(_onSearchChanged); // Ouve mudanças no campo de pesquisa
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // Função chamada quando o texto da pesquisa muda
  void _onSearchChanged() {
    _filterPerfumes(_searchController.text);
  }

  // Lógica de filtragem dos perfumes
  void _filterPerfumes(String searchTerm) {
    List<Perfume> results = [];
    if (searchTerm.isEmpty) {
      results = _allPerfumes;
    } else {
      results = _allPerfumes.where((perfume) =>
          perfume.name.toLowerCase().contains(searchTerm.toLowerCase())).toList();
    }

    // Atualiza a UI com os resultados filtrados
    setState(() {
      _foundPerfumes = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfumaria Essência', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        // O leading (ícone de menu) é automaticamente adicionado quando um Drawer está presente
        actions: [
          // Ícone de Perfil do Usuário
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black87),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tela de Perfil (em breve!)')),
              );
              // TODO: Navegar para a tela de perfil do usuário
            },
          ),
          // Ícone de Carrinho de Compras
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Carrinho de compras (em breve!)')),
              );
              // TODO: Navegar para a tela do carrinho
            },
          ),
        ],
      ),
      // Adiciona o Drawer ao Scaffold
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.person_pin, color: Colors.white, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'Olá, Usuário!', // Poderia ser o nome do usuário logado
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
                // Já estamos na Home, então não faz nada além de fechar
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Meu Perfil'),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegar para Meu Perfil')),
                );
                // TODO: Navegar para a tela de perfil
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Meus Pedidos'),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegar para Meus Pedidos')),
                );
                // TODO: Navegar para a tela de pedidos
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegar para Configurações')),
                );
                // TODO: Navegar para a tela de configurações
              },
            ),
            const Divider(), // Uma linha divisória
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Sair', style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer antes de sair
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar perfumes...',
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none, // Sem borda para um look mais limpo
                ),
                filled: true,
                fillColor: Colors.grey[200], // Fundo cinza claro para a barra de pesquisa
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              onChanged: (value) {
                // A filtragem já está acontecendo no listener do _searchController
              },
            ),
          ),
          // Exemplo de Filter Chips (futura implementação)
          // Você pode adicionar categorias ou filtros aqui, por exemplo:
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.horizontal,
          //     child: Row(
          //       children: <Widget>[
          //         FilterChip(
          //           label: const Text('Masculino'),
          //           selected: false, // Gerenciar estado de seleção
          //           onSelected: (bool selected) {
          //             // Lógica de filtragem
          //           },
          //         ),
          //         SizedBox(width: 8),
          //         FilterChip(
          //           label: const Text('Feminino'),
          //           selected: false,
          //           onSelected: (bool selected) {},
          //         ),
          //         SizedBox(width: 8),
          //         FilterChip(
          //           label: const Text('Amadeirado'),
          //           selected: false,
          //           onSelected: (bool selected) {},
          //         ),
          //         // ... mais chips
          //       ],
          //     ),
          //   ),
          // ),
          Expanded(
            child: _foundPerfumes.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum perfume encontrado.',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: _foundPerfumes.length,
                    itemBuilder: (context, index) {
                      final perfume = _foundPerfumes[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell( // Permite que o card seja clicável
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Clicou em "${perfume.name}"')),
                            );
                            // TODO: Navegar para a tela de detalhes do produto
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    perfume.imageUrl,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.broken_image,
                                        size: 90,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
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
                                        'R\$ ${perfume.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_shopping_cart, color: Colors.black87),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('"${perfume.name}" adicionado ao carrinho!')),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}