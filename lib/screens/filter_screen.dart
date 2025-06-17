import 'package:flutter/material.dart';

// Classe para representar os filtros selecionados
class PerfumeFilters {
  final List<String> selectedBrands;
  final List<String> selectedGenders;
  final RangeValues priceRange; // min e max de preço

  PerfumeFilters({
    this.selectedBrands = const [],
    this.selectedGenders = const [],
    this.priceRange = const RangeValues(0, 500), // Valores padrão
  });

  // Copia os filtros, permitindo mudar apenas alguns
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

  // Verifica se há algum filtro aplicado
  bool get hasActiveFilters {
    return selectedBrands.isNotEmpty ||
           selectedGenders.isNotEmpty ||
           priceRange.start > 0 || // Se o mínimo não for 0
           priceRange.end < 500;   // Se o máximo não for o padrão
  }
}

class FilterScreen extends StatefulWidget {
  final PerfumeFilters currentFilters; // Recebe os filtros atuais da Home

  const FilterScreen({super.key, required this.currentFilters});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // Estados locais para os filtros
  late List<String> _tempSelectedBrands;
  late List<String> _tempSelectedGenders;
  late RangeValues _tempPriceRange;

  // Opções disponíveis de filtros
  final List<String> _availableBrands = ['Luxury Scents', 'Urban Aura', 'Nature Inspired', 'Exotic Delights'];
  final List<String> _availableGenders = ['Masculino', 'Feminino', 'Unissex'];
  final double _minPrice = 0.0;
  final double _maxPrice = 500.0; // Ajuste conforme o range de preços dos seus produtos

  @override
  void initState() {
    super.initState();
    // Inicializa os estados temporários com os filtros atuais
    _tempSelectedBrands = List.from(widget.currentFilters.selectedBrands);
    _tempSelectedGenders = List.from(widget.currentFilters.selectedGenders);
    _tempPriceRange = widget.currentFilters.priceRange;
  }

  // Método para "resetar" os filtros
  void _resetFilters() {
    setState(() {
      _tempSelectedBrands.clear();
      _tempSelectedGenders.clear();
      _tempPriceRange = RangeValues(_minPrice, _maxPrice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtros', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text('Limpar', style: TextStyle(color: Colors.black54)),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Filtro por Gênero
            const Text(
              'Gênero',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Wrap( // Permite que os chips quebrem a linha automaticamente
              spacing: 8.0, // Espaçamento entre os chips
              children: _availableGenders.map((gender) {
                return FilterChip(
                  label: Text(gender),
                  selected: _tempSelectedGenders.contains(gender),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _tempSelectedGenders.add(gender);
                      } else {
                        _tempSelectedGenders.remove(gender);
                      }
                    });
                  },
                  selectedColor: Colors.black12, // Cor de fundo quando selecionado
                  checkmarkColor: Colors.black87, // Cor do ícone de check
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Filtro por Marca
            const Text(
              'Marca',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Wrap(
              spacing: 8.0,
              children: _availableBrands.map((brand) {
                return FilterChip(
                  label: Text(brand),
                  selected: _tempSelectedBrands.contains(brand),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _tempSelectedBrands.add(brand);
                      } else {
                        _tempSelectedBrands.remove(brand);
                      }
                    });
                  },
                  selectedColor: Colors.black12,
                  checkmarkColor: Colors.black87,
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Filtro por Faixa de Preço
            const Text(
              'Faixa de Preço',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            RangeSlider(
              values: _tempPriceRange,
              min: _minPrice,
              max: _maxPrice,
              divisions: 100, // Número de divisões entre min e max
              labels: RangeLabels(
                'R\$ ${_tempPriceRange.start.toStringAsFixed(2)}',
                'R\$ ${_tempPriceRange.end.toStringAsFixed(2)}',
              ),
              onChanged: (RangeValues newValues) {
                setState(() {
                  _tempPriceRange = newValues;
                });
              },
              activeColor: Colors.black87, // Cor da parte ativa do slider
              inactiveColor: Colors.grey[300], // Cor da parte inativa
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('R\$ ${_tempPriceRange.start.toStringAsFixed(2)}'),
                  Text('R\$ ${_tempPriceRange.end.toStringAsFixed(2)}'),
                ],
              ),
            ),
            const SizedBox(height: 48),

            // Botão Aplicar Filtros
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Retorna os filtros selecionados para a tela anterior (HomeScreen)
                  Navigator.pop(
                    context,
                    PerfumeFilters(
                      selectedBrands: _tempSelectedBrands,
                      selectedGenders: _tempSelectedGenders,
                      priceRange: _tempPriceRange,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Aplicar Filtros',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}