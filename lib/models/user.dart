class User {
  int id;
  String name;
  String email;
  String number;

  User({
    this.id,
    this.name,
    this.email,
    this.number,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      number: json['number'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "email": email,
      "number": number,
    };
  }
}
