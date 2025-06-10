import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/screens/welcome_screen.dart'; // Importa a tela de boas-vindas para o logout
import 'package:perfumes_ecomerce/models/perfume.dart'; // Importa nosso modelo de Perfume
import 'package:perfumes_ecomerce/screens/profile_screen.dart'; // Importa a tela de perfil
import 'package:perfumes_ecomerce/screens/product_detail_screen.dart'; // Importa a tela de detalhes do produto
import 'package:perfumes_ecomerce/screens/cart_screen.dart'; // Importa a tela do carrinho
import 'package:perfumes_ecomerce/screens/my_orders_screen.dart'; // Importa a tela de Meus Pedidos
import 'package:perfumes_ecomerce/screens/filter_screen.dart'; // Importa a tela de filtros e o modelo PerfumeFilters

// A Home Screen agora será um StatefulWidget para gerenciar o estado da pesquisa
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lista original de todos os perfumes
  final List<Perfume> _allPerfumes = [
    Perfume(
      name: 'Perfume Elegance',
      imageUrl: 'https://via.placeholder.com/200/A3B8B8/FFFFFF?text=Perfume1',
      price: 199.99,
      brand: 'Luxury Scents', // Adicionado
      gender: 'Feminino', // Adicionado
    ),
    Perfume(
      name: 'Essência Noturna',
      imageUrl: 'https://via.placeholder.com/200/8D9898/FFFFFF?text=Perfume2',
      price: 249.90,
      brand: 'Urban Aura',
      gender: 'Masculino',
    ),
    Perfume(
      name: 'Aroma da Primavera',
      imageUrl: 'https://via.placeholder.com/200/C6D8D8/000000?text=Perfume3',
      price: 150.00,
      brand: 'Nature Inspired',
      gender: 'Unissex',
    ),
    Perfume(
      name: 'Toque Amadeirado',
      imageUrl: 'https://via.placeholder.com/200/667373/FFFFFF?text=Perfume4',
      price: 280.50,
      brand: 'Luxury Scents',
      gender: 'Masculino',
    ),
    Perfume(
      name: 'Doce Tentação',
      imageUrl: 'https://via.placeholder.com/200/A7B8B8/FFFFFF?text=Perfume5',
      price: 175.25,
      brand: 'Urban Aura',
      gender: 'Feminino',
    ),
    Perfume(
      name: 'Mistério Oriental',
      imageUrl: 'https://via.placeholder.com/200/9F8B9B/FFFFFF?text=Perfume6',
      price: 320.00,
      brand: 'Exotic Delights',
      gender: 'Unissex',
    ),
    Perfume(
      name: 'Frescor do Oceano',
      imageUrl: 'https://via.placeholder.com/200/B8D8D8/000000?text=Perfume7',
      price: 210.00,
      brand: 'Nature Inspired',
      gender: 'Masculino',
    ),
    Perfume(
      name: 'Sonho Dourado',
      imageUrl: 'https://via.placeholder.com/200/FFD700/000000?text=Perfume8',
      price: 270.00,
      brand: 'Luxury Scents',
      gender: 'Feminino',
    ),
    Perfume(
      name: 'Poder Urbano',
      imageUrl: 'https://via.placeholder.com/200/404040/FFFFFF?text=Perfume9',
      price: 295.00,
      brand: 'Urban Aura',
      gender: 'Masculino',
    ),
    Perfume(
      // Adicione mais um para ter mais opções
      name: 'Flor do Campo',
      imageUrl: 'https://via.placeholder.com/200/E6E6FA/000000?text=Perfume10',
      price: 180.00,
      brand: 'Nature Inspired',
      gender: 'Feminino',
    ),
  ];

  PerfumeFilters _currentFilters =
      PerfumeFilters(); // Inicializa com filtros padrão (nenhum filtro ativo)

  // Lista de perfumes que será exibida (filtrada pela pesquisa)
  List<Perfume> _foundPerfumes = [];
  final TextEditingController _searchController = TextEditingController();

@override
void initState() {
  super.initState();
  // Não precisamos mais do _foundPerfumes = _allPerfumes aqui,
  // pois _filterPerfumes já fará isso se a pesquisa e filtros estiverem vazios.
  _searchController.addListener(_onSearchChanged);
  _filterPerfumes(_searchController.text); // Chama para aplicar os filtros iniciais
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
      results = _allPerfumes
          .where((perfume) =>
              perfume.name.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    }

    // Aplica os filtros adicionais
    results = results.where((perfume) {
      // Filtro por marca
      if (_currentFilters.selectedBrands.isNotEmpty &&
          !_currentFilters.selectedBrands.contains(perfume.brand)) {
        return false; // Remove se a marca não estiver selecionada
      }
      // Filtro por gênero
      if (_currentFilters.selectedGenders.isNotEmpty &&
          !_currentFilters.selectedGenders.contains(perfume.gender)) {
        return false; // Remove se o gênero não estiver selecionado
      }
      // Filtro por faixa de preço
      if (perfume.price < _currentFilters.priceRange.start ||
          perfume.price > _currentFilters.priceRange.end) {
        return false; // Remove se o preço estiver fora da faixa
      }
      return true; // Mantém o perfume se ele passar por todos os filtros
    }).toList();

    setState(() {
      _foundPerfumes = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfumaria Essência',
            style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        // O leading (ícone de menu) é automaticamente adicionado quando um Drawer está presente
        actions: [
          Stack(
            // Usa Stack para sobrepor o ícone de filtro com um indicador
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.black87),
                onPressed: () async {
                  // Navega para a FilterScreen e espera o resultado
                  final selectedFilters = await Navigator.push<PerfumeFilters>(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FilterScreen(currentFilters: _currentFilters),
                    ),
                  );
                  // Se o usuário aplicou filtros e não apenas voltou
                  if (selectedFilters != null) {
                    setState(() {
                      _currentFilters =
                          selectedFilters; // Atualiza os filtros da Home
                    });
                    _filterPerfumes(_searchController
                        .text); // Re-aplica a pesquisa e os novos filtros
                  }
                },
              ),
              if (_currentFilters
                  .hasActiveFilters) // Exibe um indicador se há filtros ativos
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red, // Cor para o indicador de filtro ativo
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: const Text(
                      '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
          // Ícone de Perfil do Usuário
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          // Ícone de Carrinho de Compras
          IconButton(
            icon:
                const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      // Adiciona o Drawer ao Scaffold
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              // Adicionado 'const' aqui
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.person_pin, color: Colors.white, size: 48),
                  SizedBox(height: 8),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Meus Pedidos'),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyOrdersScreen()),
                );
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
              title:
                  const Text('Sair', style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer antes de sair
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WelcomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Alinha os filhos à esquerda
        children: <Widget>[
          // Campo de Pesquisa
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Pesquisar perfumes...',
                prefixIcon: const Icon(Icons.search, color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide.none, // Sem borda para um look mais limpo
                ),
                filled: true,
                fillColor: Colors
                    .grey[200], // Fundo cinza claro para a barra de pesquisa
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              onChanged: (value) {
                // A filtragem já está acontecendo no listener do _searchController
              },
            ),
          ),
          // Grade de Produtos
          Expanded(
            child: _foundPerfumes.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum perfume encontrado.',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  )
                : GridView.builder(
                    // Mantido o GridView.builder
                    padding:
                        const EdgeInsets.all(16.0), // Padding em volta da grade
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Duas colunas
                      crossAxisSpacing:
                          16.0, // Espaçamento horizontal entre os itens
                      mainAxisSpacing:
                          16.0, // Espaçamento vertical entre as linhas
                      childAspectRatio:
                          0.7, // Proporção largura/altura de cada item
                    ),
                    itemCount: _foundPerfumes.length,
                    itemBuilder: (context, index) {
                      final perfume = _foundPerfumes[index];

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          // Permite que o card seja clicável
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                    perfume: perfume), // Passa o objeto perfume
                              ),
                            );
                          },
                          child: Column(
                            // Alterado para Column para empilhar imagem, nome e preço
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Alinha o texto à esquerda
                            children: <Widget>[
                              Expanded(
                                // A imagem ocupa o espaço disponível na altura
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(
                                          10)), // Apenas bordas superiores arredondadas
                                  child: Image.network(
                                    perfume.imageUrl,
                                    width: double
                                        .infinity, // Ocupa a largura total do card
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
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      perfume.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 1, // Limita o texto a uma linha
                                      overflow: TextOverflow
                                          .ellipsis, // Adiciona "..." se o texto for muito longo
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'R\$ ${perfume.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                // Alinha o botão "adicionar" ao final do card
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  icon: const Icon(Icons.add_shopping_cart,
                                      color: Colors.black87),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '"${perfume.name}" adicionado ao carrinho!')),
                                    );
                                  },
                                ),
                              ),
                            ],
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
