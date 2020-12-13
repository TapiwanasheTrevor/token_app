class Token {
  int id;
  int units;
  String price;
  String token;

  Token({this.id, this.units, this.price, this.token});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
        id: json['id'],
        units: json['units'],
        price: json['price'],
        token: json['token']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "units": units,
      "price": token,
      "token": token
    };
  }
}
