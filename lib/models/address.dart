class Address {
  final int? id;
  final int userId;
  final String street;
  final String number;
  final String? complement;
  final String neighborhood;
  final String city;
  final String state;
  final String zipCode;
  final bool isDefault;
  final DateTime createdAt;

  Address({
    this.id,
    required this.userId,
    required this.street,
    required this.number,
    this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.zipCode,
    this.isDefault = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'street': street,
      'number': number,
      'complement': complement,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'is_default': isDefault ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'],
      userId: map['user_id'],
      street: map['street'],
      number: map['number'],
      complement: map['complement'],
      neighborhood: map['neighborhood'],
      city: map['city'],
      state: map['state'],
      zipCode: map['zip_code'],
      isDefault: map['is_default'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }
} 