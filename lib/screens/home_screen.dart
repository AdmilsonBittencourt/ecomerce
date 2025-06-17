import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/screens/welcome_screen.dart';
import 'package:perfumes_ecomerce/models/perfume.dart';
import 'package:perfumes_ecomerce/screens/profile_screen.dart';
import 'package:perfumes_ecomerce/screens/product_detail_screen.dart';
import 'package:perfumes_ecomerce/screens/cart_screen.dart';
import 'package:perfumes_ecomerce/screens/my_orders_screen.dart';
import 'package:perfumes_ecomerce/screens/filter_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
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
      PerfumeFilters(); 

  
  List<Perfume> _foundPerfumes = [];
  final TextEditingController _searchController = TextEditingController();

@override
void initState() {
  super.initState();
  
  _searchController.addListener(_onSearchChanged);
}

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  
  void _onSearchChanged() {
    _filterPerfumes(_searchController.text);
  }

  
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

    
    results = results.where((perfume) {
      
      if (_currentFilters.selectedBrands.isNotEmpty &&
          !_currentFilters.selectedBrands.contains(perfume.brand)) {
        return false;
      }
      
      if (_currentFilters.selectedGenders.isNotEmpty &&
          !_currentFilters.selectedGenders.contains(perfume.category)) {
        return false;
      }
      
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
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF800020),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Stack(
            
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.white),
                onPressed: () async {
                  
                  final selectedFilters = await Navigator.push<PerfumeFilters>(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FilterScreen(currentFilters: _currentFilters),
                    ),
                  );
                  
                  if (selectedFilters != null) {
                    setState(() {
                      _currentFilters =
                          selectedFilters; 
                    });
                    _filterPerfumes(_searchController
                        .text); 
                  }
                },
              ),
              if (_currentFilters
                  .hasActiveFilters) 
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red, 
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
          
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          
          IconButton(
            icon:
                const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              
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
                    'Olá, Usuário!', 
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
                Navigator.pop(context); 
                
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Meu Perfil'),
              onTap: () {
                Navigator.pop(context); 
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
                Navigator.pop(context); 
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
                Navigator.pop(context); 
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegar para Configurações')),
                );

              },
            ),
            const Divider(), 
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title:
                  const Text('Sair', style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pop(context); 
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
            CrossAxisAlignment.start, 
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
                  borderSide:
                      BorderSide.none, 
                ),
                filled: true,
                fillColor: Colors
                    .grey[200], 
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              onChanged: (value) {
                
              },
            ),
          ),
          
          Expanded(
            child: _foundPerfumes.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum perfume encontrado.',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  )
                : GridView.builder(
                    
                    padding:
                        const EdgeInsets.all(16.0), 
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, 
                      crossAxisSpacing:
                          16.0, 
                      mainAxisSpacing:
                          16.0, 
                      childAspectRatio:
                          0.7, 
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
                          
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                    perfume: perfume), 
                              ),
                            );
                          },
                          child: Column(
                            
                            crossAxisAlignment: CrossAxisAlignment
                                .start, 
                            children: <Widget>[
                              Expanded(
                                
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(
                                          10)), 
                                  child: Image.network(
                                    perfume.imageUrl,
                                    width: double
                                        .infinity, 
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
                                      maxLines: 1, 
                                      overflow: TextOverflow
                                          .ellipsis, 
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
