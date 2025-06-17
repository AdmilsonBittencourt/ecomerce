class Address {
  final String street;
  final String city;
  final String zipCode;
  final String country;

  Address({
    required this.street,
    required this.city,
    required this.zipCode,
    required this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'zipCode': zipCode,
      'country': country,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      street: map['street'],
      city: map['city'],
      zipCode: map['zipCode'],
      country: map['country'],
    );
  }
}