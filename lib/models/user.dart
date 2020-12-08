class User {
  int id;
  String name;
  String email;
  String meter;
  String number;

  User({
    this.id,
    this.name,
    this.email,
    this.meter,
    this.number,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      meter: json['meter'],
      number: json['number'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "name": name,
      "email": email,
      "meter": meter,
      "number": number,
    };
  }
}
