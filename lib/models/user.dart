class User {
  final int? id;
  final String name;
  final String email;
  final String? phone;
  final DateTime createdAt;
  final String password;

  User({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    DateTime? createdAt,
    required this.password,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      createdAt: DateTime.parse(map['created_at']),
      password: map['password'],
    );
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    DateTime? createdAt,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      password: password ?? this.password,
    );
  }
} 