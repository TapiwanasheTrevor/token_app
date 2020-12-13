class Meter {
  int id;
  String number;
  String address;
  int units;

  Meter({this.id, this.number, this.address, this.units});

  factory Meter.fromJson(Map<String, dynamic> json) {
    return Meter(
        id: json['id'],
        number: json['number'],
        address: json['address'],
        units: json['units']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "number": number,
      "address": address,
      "units": units
    };
  }
}
