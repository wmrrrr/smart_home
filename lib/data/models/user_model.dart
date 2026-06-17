class UserModel {
  const UserModel({
    required this.name,
    required this.email,
    required this.passwordHash,
    this.phone = '',
    this.city = '',
  });

  factory UserModel.fromJson(final Map<String, dynamic> json) => UserModel(
        name: json['name'] as String,
        email: json['email'] as String,
        passwordHash: json['passwordHash'] as String,
        phone: (json['phone'] as String?) ?? '',
        city: (json['city'] as String?) ?? '',
      );

  final String name;
  final String email;
  final String passwordHash;
  final String phone;
  final String city;

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'passwordHash': passwordHash,
        'phone': phone,
        'city': city,
      };

  UserModel copyWith({
    String? name,
    String? email,
    String? passwordHash,
    String? phone,
    String? city,
  }) =>
      UserModel(
        name: name ?? this.name,
        email: email ?? this.email,
        passwordHash: passwordHash ?? this.passwordHash,
        phone: phone ?? this.phone,
        city: city ?? this.city,
      );
}
