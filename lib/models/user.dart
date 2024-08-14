class User {
  final String noTelepon;
  final String token;

  User({
    required this.noTelepon,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      noTelepon: json['no_telepon'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'no_telepon': noTelepon,
      'token': token,
    };
  }
}
