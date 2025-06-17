class CartItem {
  final int? id;         // ID do item no banco local (gerado pelo SQFlite)
  final String perfumeId; // ID do Perfume (a chave de ligação)
  final String name;       // Denormalizado para fácil exibição
  final double price;      // Preço no momento da adição
  final String imageUrl;   // URL da imagem para fácil exibição no carrinho
  int quantity;

  CartItem({
    this.id,
    required this.perfumeId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });
  
  // Getter mantido, é muito útil!
  double get totalPrice => price * quantity;

  // Converte um objeto CartItem em um Map para o SQFlite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': perfumeId, // Nome da coluna como definimos no DatabaseHelper
      'name': name,
      'price': price,
      'imageUrl': imageUrl, // Vamos adicionar esta coluna no banco
      'quantity': quantity,
    };
  }

  // Converte um Map do SQFlite em um objeto CartItem
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      perfumeId: map['productId'],
      name: map['name'],
      price: map['price'],
      imageUrl: map['imageUrl'],
      quantity: map['quantity'],
    );
  }
}