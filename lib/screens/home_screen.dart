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
      id: 1,
      name: 'Chanel N°5 Eau de Parfum',
      description: 'Um clássico atemporal com notas de aldeído, jasmim e rosa.',
      imageUrl: 'https://cdn.awsli.com.br/600x450/364/364776/produto/100096084/0e1734d8f6.jpg',
      price: 299.99,
      brand: 'Chanel',
      category: 'Feminino',
    ),
    Perfume(
      id: 2,
      name: 'Dior Sauvage Eau de Parfum',
      description: 'Uma fragrância masculina intensa com notas de bergamota e ambroxan.',
      imageUrl: 'https://cdn.vnda.com.br/950x/delmondostore/2021/08/20/19_8_2_227_DIOR_SAUVAGEEDP_01.jpg?v=1629498814',
      price: 249.90,
      brand: 'Dior',
      category: 'Masculino',
    ),
    Perfume(
      id: 3,
      name: 'Jo Malone London Wood Sage & Sea Salt',
      description: 'Uma fragrância unissex com notas de sal marinho e sálvia.',
      imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhzWzkvuneDC1xdftofnHjN8MjtEPQ5DTF7g&s',
      price: 150.00,
      brand: 'Jo Malone',
      category: 'Unissex',
    ),
    Perfume(
      id: 4,
      name: 'Tom Ford Oud Wood',
      description: 'Uma fragrância oriental com notas de oud, sândalo e baunilha.',
      imageUrl: 'https://www.mundodosdecants.com.br/wp-content/uploads/2024/11/Tom-Ford-Oud-Wood-Parfum.jpg',
      price: 280.50,
      brand: 'Tom Ford',
      category: 'Masculino',
    ),
    Perfume(
      id: 5,
      name: 'Yves Saint Laurent Black Opium',
      description: 'Uma fragrância feminina viciante com notas de café e baunilha.',
      imageUrl: 'https://www.giraofertas.com.br/wp-content/uploads/2021/05/Black-Opium-Yves-Saint-Laurent-Eau-de-Parfum-05.jpg',
      price: 175.25,
      brand: 'Yves Saint Laurent',
      category: 'Feminino',
    ),
    Perfume(
      id: 6,
      name: 'Maison Margiela Replica Jazz Club',
      description: 'Uma fragrância unissex inspirada em bares de jazz dos anos 50.',
      imageUrl: 'https://cdn.awsli.com.br/2500x2500/364/364776/produto/109874128/5d4ece98bc.jpg',
      price: 320.00,
      brand: 'Maison Margiela',
      category: 'Unissex',
    ),
    Perfume(
      id: 7,
      name: 'Acqua di Parma Colonia',
      description: 'Uma fragrância cítrica clássica com notas de bergamota e lavanda.',
      imageUrl: 'https://www.giraofertas.com.br/wp-content/uploads/2019/07/Acqua-di-Parma-Colonia-Essenza-02.jpg',
      price: 210.00,
      brand: 'Acqua di Parma',
      category: 'Masculino',
    ),
    Perfume(
      id: 8,
      name: 'Gucci Bloom Eau de Parfum',
      description: 'Uma fragrância floral com notas de tuberosa e jasmim.',
      imageUrl: 'https://www.sephora.com.br/dw/image/v2/BFJC_PRD/on/demandware.static/-/Sites-masterCatalog_Sephora/pt_BR/dwae39dfff/images/hi-res-BR/prd27376.jpg?sw=556&sh=680&sm=fit',
      price: 270.00,
      brand: 'Gucci',
      category: 'Feminino',
    ),
    Perfume(
      id: 9,
      name: 'Bleu de Chanel Eau de Parfum',
      description: 'Uma fragrância masculina sofisticada com notas de cítricos e madeiras.',
      imageUrl: 'https://acdn-us.mitiendanube.com/stores/003/728/105/products/perfume_fotos_bleu-de-chanel-ff353eadca63bffaa217152001809211-1024-1024.jpg',
      price: 295.00,
      brand: 'Chanel',
      category: 'Masculino',
    ),
    Perfume(
      id: 10,
      name: 'Byredo Gypsy Water',
      description: 'Uma fragrância unissex com notas de bergamota, pimenta e baunilha.',
      imageUrl: 'https://i0.wp.com/www.sprayparfums.com/wp-content/uploads/2024/06/0by1p100gypsywa_2.jpg?fit=430%2C568&ssl=1',
      price: 180.00,
      brand: 'Byredo',
      category: 'Unissex',
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
        return false;
      }
      // Filtro por categoria (anteriormente gender)
      if (_currentFilters.selectedGenders.isNotEmpty &&
          !_currentFilters.selectedGenders.contains(perfume.category)) {
        return false;
      }
      // Filtro por faixa de preço
      if (perfume.price < _currentFilters.priceRange.start ||
          perfume.price > _currentFilters.priceRange.end) {
        return false;
      }
      return true;
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
                    child: Text(
                      _foundPerfumes.length.toString(),
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
