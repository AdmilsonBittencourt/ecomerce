class Perfume {
  final String name;
  final String imageUrl;
  final double price;
  final String brand; // Nova propriedade: marca
  final String gender; // Nova propriedade: gênero (ex: Masculino, Feminino, Unissex)

  Perfume({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.brand, // Adicionado ao construtor
    required this.gender, // Adicionado ao construtor
  });
}