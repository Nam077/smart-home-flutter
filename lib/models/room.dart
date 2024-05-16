import 'device.dart';

class Room {
  int id;
  String name;
  String description;
  List<Device>? devices;

  Room({
    required this.id,
    required this.name,
    required this.description,
    this.devices,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      devices: json['devices'] != null
          ? (json['devices'] as List).map((i) => Device.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'devices': devices?.map((device) => device.toJson()).toList(),
    };
  }
}
