import 'package:flutter/material.dart';
import 'package:perfumes_ecomerce/perfume_filter.dart';
 // Importe a classe que acabamos de criar

class FilterScreen extends StatefulWidget {
  final PerfumeFilters currentFilters; // Recebe os filtros atuais da tela de produtos

  const FilterScreen({super.key, required this.currentFilters});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // Estados locais temporários para o usuário poder "brincar" com os filtros
  late List<String> _tempSelectedBrands;
  late List<String> _tempSelectedGenders;
  late RangeValues _tempPriceRange;

  // DICA: Em uma versão futura, você pode buscar essas marcas dinamicamente 
  // do seu banco de dados para que a lista esteja sempre atualizada!
  final List<String> _availableBrands = ['Giorgio Armani', 'Chanel', 'Calvin Klein'];
  final List<String> _availableGenders = ['Masculino', 'Feminino', 'Unissex'];
  
  @override
  void initState() {
    super.initState();
    // Inicializa os estados temporários com os filtros que a tela recebeu
    _tempSelectedBrands = List.from(widget.currentFilters.selectedBrands);
    _tempSelectedGenders = List.from(widget.currentFilters.selectedGenders);
    _tempPriceRange = widget.currentFilters.priceRange;
  }

  void _resetFilters() {
    setState(() {
      _tempSelectedBrands.clear();
      _tempSelectedGenders.clear();
      _tempPriceRange = const RangeValues(PerfumeFilters.minPrice, PerfumeFilters.maxPrice);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtros'),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: const Text('Limpar'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Seção de Gênero
            const Text('Gênero', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Wrap(
              spacing: 8.0,
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
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Seção de Marca
            const Text('Marca', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Seção de Faixa de Preço
            const Text('Faixa de Preço', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RangeSlider(
              values: _tempPriceRange,
              min: PerfumeFilters.minPrice,
              max: PerfumeFilters.maxPrice,
              divisions: 100,
              labels: RangeLabels(
                'R\$ ${_tempPriceRange.start.round()}',
                'R\$ ${_tempPriceRange.end.round()}',
              ),
              onChanged: (RangeValues newValues) {
                setState(() {
                  _tempPriceRange = newValues;
                });
              },
            ),
            const SizedBox(height: 48),

            // Botão para aplicar os filtros e voltar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // Cria um novo objeto PerfumeFilters com as seleções temporárias
                  final newFilters = PerfumeFilters(
                    selectedBrands: _tempSelectedBrands,
                    selectedGenders: _tempSelectedGenders,
                    priceRange: _tempPriceRange,
                  );
                  // Devolve o objeto para a tela anterior
                  Navigator.pop(context, newFilters);
                },
                child: const Text('Aplicar Filtros', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}