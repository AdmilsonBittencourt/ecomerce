import 'package:flutter/material.dart';

class PerfumeFilters {
  final List<String> selectedBrands;
  final List<String> selectedGenders;
  final RangeValues priceRange;

  PerfumeFilters({
    this.selectedBrands = const [],
    this.selectedGenders = const [],
    this.priceRange = const RangeValues(0, 500),
  });

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

  bool get hasActiveFilters {
    return selectedBrands.isNotEmpty ||
           selectedGenders.isNotEmpty ||
           priceRange.start > 0 ||
           priceRange.end < 500;
  }
}

class FilterScreen extends StatefulWidget {
  final PerfumeFilters currentFilters;

  const FilterScreen({super.key, required this.currentFilters});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late List<String> _tempSelectedBrands;
  late List<String> _tempSelectedGenders;
  late RangeValues _tempPriceRange;

  final List<String> _availableBrands = ['Luxury Scents', 'Urban Aura', 'Nature Inspired', 'Exotic Delights'];
  final List<String> _availableGenders = ['Masculino', 'Feminino', 'Unissex'];
  final double _minPrice = 0.0;
  final double _maxPrice = 500.0;

  @override
  void initState() {
    super.initState();
    _tempSelectedBrands = List.from(widget.currentFilters.selectedBrands);
    _tempSelectedGenders = List.from(widget.currentFilters.selectedGenders);
    _tempPriceRange = widget.currentFilters.priceRange;
  }

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
            const Text(
              'Gênero',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
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
                  selectedColor: Colors.black12, 
                  checkmarkColor: Colors.black87, 
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

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
              divisions: 100, 
              labels: RangeLabels(
                'R\$ ${_tempPriceRange.start.toStringAsFixed(2)}',
                'R\$ ${_tempPriceRange.end.toStringAsFixed(2)}',
              ),
              onChanged: (RangeValues newValues) {
                setState(() {
                  _tempPriceRange = newValues;
                });
              },
              activeColor: Colors.black87, 
              inactiveColor: Colors.grey[300], 
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

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                        
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