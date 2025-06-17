import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/db/database_helper.dart';
import 'package:perfumes_ecomerce/models/perfume.dart';
import 'package:perfumes_ecomerce/perfume_filter.dart';
import 'package:perfumes_ecomerce/screens/product_list.dart';

class PerfumeManager extends ChangeNotifier {
  List<Perfume> _perfumes = [];
  bool _isLoading = true;
  PerfumeFilters _activeFilters = PerfumeFilters(); // Guarda os filtros ativos
  String _searchTerm = '';

  List<Perfume> get perfumes => _perfumes;
  bool get isLoading => _isLoading;
  PerfumeFilters get activeFilters => _activeFilters;

  PerfumeManager() {
    fetchPerfumes(); // Busca inicial sem filtros
  }

  /// Busca os perfumes no banco, aplicando os filtros ativos.
  Future<void> fetchPerfumes() async {
    _isLoading = true;
    notifyListeners();
    // ATUALIZADO: Passa os filtros E o termo de busca
    _perfumes = await DatabaseHelper.instance.getPerfumes(
      filters: _activeFilters,
      searchTerm: _searchTerm,
    );
    _isLoading = false;
    notifyListeners();
  }

  /// Atualiza os filtros ativos e busca novamente os perfumes.
  Future<void> applyFilters(PerfumeFilters newFilters) async {
    _activeFilters = newFilters;
    await fetchPerfumes(); // Re-executa a busca com os novos filtros
  }

  Future<void> search(String term) async {
    _searchTerm = term;
    await fetchPerfumes(); // Re-executa a busca com o novo termo
  }
}