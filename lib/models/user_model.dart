class User {
  String? userId;
  String? name;
  String? email;
  String? password;

  User({this.userId, this.name, this.email, this.password});

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json['user_id']?.toString(),
    name: json['name'] as String?,
    email: json['email'] as String?,
    // No la uses a menos que sea intencional
    password: json['password'] as String?,
  );

  /// Úsalo solo para enviar datos al crear usuario
  Map<String, dynamic> toJsonForCreate() => {
    if (name != null) "name": name,
    if (email != null) "email": email,
    if (password != null) "password": password,
  };

  /// Para actualizar o enviar usuario sin exponer la password
  Map<String, dynamic> toJson() => {
    if (userId != null) "user_id": userId,
    if (name != null) "name": name,
    if (email != null) "email": email,
  };

  @override
  String toString() => '''
User {
  userId: $userId,
  name: $name,
  email: $email
}
''';
}
