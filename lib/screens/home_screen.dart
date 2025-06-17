import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/perfume_filter.dart';
import 'package:perfumes_ecomerce/perfume_manager.dart';
import 'package:perfumes_ecomerce/screens/filter.dart';
import 'package:perfumes_ecomerce/screens/my_orders_screen.dart';
import 'package:perfumes_ecomerce/screens/product_detail_screen.dart';
import 'package:perfumes_ecomerce/screens/profile_screen.dart';
import 'package:perfumes_ecomerce/shared_widgets/cart_badge.dart';
import 'package:perfumes_ecomerce/user_manager.dart';
import 'package:provider/provider.dart';
 // Importe o novo badge

// MUDOU: Agora pode ser um StatelessWidget!
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos um único Consumer para o PerfumeManager, pois ele dirige a tela principal.
    // Os outros managers podem ser acessados com Provider.of se necessário.
    return Consumer<PerfumeManager>(
      builder: (context, perfumeManager, child) {
        final userManager = Provider.of<UserManager>(context, listen: false);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Perfumaria Essência'),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.filter_list,
                  color: perfumeManager.activeFilters.hasActiveFilters ? Theme.of(context).primaryColor : null,
                ),
                onPressed: () async {
                  final newFilters = await Navigator.push<PerfumeFilters>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FilterScreen(currentFilters: perfumeManager.activeFilters),
                    ),
                  );
                  if (newFilters != null) {
                    perfumeManager.applyFilters(newFilters);
                  }
                },
              ),
              const CartBadge(), // NOVO: Usando nosso widget de badge
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.black87),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.person_pin, color: Colors.white, size: 48),
                      const Spacer(),
                      // ATUALIZADO: Mostra o nome do usuário do UserManager
                      Text(
                        'Olá, ${userManager.user?.name ?? "Usuário"}!',
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Meu Perfil'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Meus Pedidos'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const MyOrdersScreen()));
                  },
                ),
                // ... outros itens do drawer ...
              ],
            ),
          ),
          body: Column(
            children: <Widget>[
              // Campo de Pesquisa
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  // ATUALIZADO: A lógica de busca agora chama o manager
                  onChanged: (value) {
                    perfumeManager.search(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Pesquisar perfumes...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              // Grade de Produtos
              Expanded(
                child: perfumeManager.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : perfumeManager.perfumes.isEmpty
                        ? const Center(child: Text('Nenhum perfume encontrado.'))
                        // ATUALIZADO: A grade usa os dados do perfumeManager
                        : GridView.builder(
                            padding: const EdgeInsets.all(16.0),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16.0,
                              mainAxisSpacing: 16.0,
                              childAspectRatio: 0.7,
                            ),
                            itemCount: perfumeManager.perfumes.length,
                            itemBuilder: (context, index) {
                              final perfume = perfumeManager.perfumes[index];
                              return Card(
                                // ... O Card do seu produto para exibir o perfume
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetailScreen(perfume: perfume),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Expanded(child: Image.network(perfume.imageUrl, fit: BoxFit.cover)),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(perfume.name, overflow: TextOverflow.ellipsis),
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
      },
    );
  }
}