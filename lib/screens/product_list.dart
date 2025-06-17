import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/perfume_filter.dart';
import 'package:perfumes_ecomerce/perfume_manager.dart';
import 'package:perfumes_ecomerce/screens/filter.dart';
import 'package:provider/provider.dart';
// ... outros imports ...

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos o Consumer para ouvir as mudanças no PerfumeManager
    return Consumer<PerfumeManager>(
      builder: (context, perfumeManager, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Catálogo'),
            actions: [
              // Botão de Filtro
              IconButton(
                icon: Icon(
                  Icons.filter_list,
                  // Muda de cor se houver filtros ativos
                  color: perfumeManager.activeFilters.hasActiveFilters ? Colors.blue : null,
                ),
                onPressed: () async {
                  // Abre a tela de filtros e espera o resultado
                  final PerfumeFilters? newFilters = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FilterScreen(
                        // Passa os filtros atualmente ativos para a tela de filtro
                        currentFilters: perfumeManager.activeFilters,
                      ),
                    ),
                  );
                  
                  // Se o usuário aplicou novos filtros (não apenas voltou), atualiza
                  if (newFilters != null) {
                    perfumeManager.applyFilters(newFilters);
                  }
                },
              ),
              // ... seu botão de carrinho ...
            ],
          ),
          body: perfumeManager.isLoading
              ? const Center(child: CircularProgressIndicator())
              : perfumeManager.perfumes.isEmpty
                  ? const Center(child: Text('Nenhum perfume encontrado com estes filtros.'))
                  : ListView.builder(
                      // A lista agora usa os dados do perfumeManager
                      itemCount: perfumeManager.perfumes.length,
                      itemBuilder: (context, index) {
                        final perfume = perfumeManager.perfumes[index];
                        // ... seu Card/ListTile para exibir o perfume ...
                        return Card(child: ListTile(title: Text(perfume.name)));
                      },
                    ),
        );
      },
    );
  }
}