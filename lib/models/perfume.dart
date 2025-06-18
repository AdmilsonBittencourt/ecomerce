class Perfume {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String brand;
  final String category;
  final bool isFavorite;

  Perfume({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.brand,
    required this.category,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image_url': imageUrl,
      'brand': brand,
      'category': category,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  factory Perfume.fromMap(Map<String, dynamic> map) {
    return Perfume(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      imageUrl: map['image_url'],
      brand: map['brand'],
      category: map['category'],
      isFavorite: map['is_favorite'] == 1,
    );
  }

  Perfume copyWith({
    int? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? brand,
    String? category,
    bool? isFavorite,
  }) {
    return Perfume(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}