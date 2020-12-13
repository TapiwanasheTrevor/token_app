class Device {
  String icon;
  String name;
  String description;
  int wattage;

  Device({this.icon, this.name, this.description, this.wattage});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
        icon: json['icon'],
        name: json['name'],
        description: json['description'],
        wattage: json['wattage']);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "icon": icon,
      "name": name,
      "address": description,
      "wattage": wattage,
    };
  }
}
