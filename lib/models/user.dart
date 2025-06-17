class UserModel {
  final int id;
  final String name;
  final String email;
  final String address;
  final String hashedPassword;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.hashedPassword,
  });

  /// ADICIONE ESTE MÉTODO
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? address,
    String? hashedPassword,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      hashedPassword: hashedPassword ?? this.hashedPassword,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'address': address,
      'hashedPassword': hashedPassword, // <-- ADICIONADO AO MAPA
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      address: map['address'],
      hashedPassword: map['hashedPassword'], // <-- LIDO DO MAPA
    );
  }
}