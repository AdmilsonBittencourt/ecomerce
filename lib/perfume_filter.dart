import 'package:flutter/material.dart';

// Classe para representar os filtros selecionados
class PerfumeFilters {
  final List<String> selectedBrands;
  final List<String> selectedGenders;
  final RangeValues priceRange;

  // Valores padrão para quando nenhum filtro é aplicado
  static const double minPrice = 0.0;
  static const double maxPrice = 1000.0; // Aumentei o valor máximo para dar mais margem

  PerfumeFilters({
    this.selectedBrands = const [],
    this.selectedGenders = const [],
    this.priceRange = const RangeValues(minPrice, maxPrice),
  });

  /// Método útil para criar uma cópia dos filtros, alterando apenas o que for necessário.
  PerfumeFilters copyWith({
    List<String>? selectedBrands,
    List<String>? selectedGenders,
    RangeValues? priceRange,
  }) {
    return PerfumeFilters(
      selectedBrands: selectedBrands ?? this.selectedBrands,
      selectedGenders: selectedGenders ?? this.selectedGenders,
      priceRange: priceRange ?? this.priceRange,
    );
  }

  /// Verifica se há algum filtro ativo para, por exemplo, mudar a cor do ícone de filtro.
  bool get hasActiveFilters {
    return selectedBrands.isNotEmpty ||
        selectedGenders.isNotEmpty ||
        priceRange.start > minPrice ||
        priceRange.end < maxPrice;
  }
}