class Perfume {
  final String id; // <-- ADICIONADO: ID único vindo da sua API
  final String name;
  final String imageUrl;
  final double price;
  final String brand;
  final String gender;

  Perfume({
    required this.id, // <-- ADICIONADO
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.brand,
    required this.gender,
  });

  // MÉTODO ADICIONADO: Para criar um Perfume a partir de um Map (ex: vindo de uma API)
  factory Perfume.fromMap(Map<String, dynamic> map) {
    return Perfume(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      price: map['price'],
      brand: map['brand'],
      gender: map['gender'],
    );
  }

  // MÉTODO ADICIONADO: Para converter o Perfume para um Map (útil para logs ou outras operações)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'brand': brand,
      'gender': gender,
    };
  }
}