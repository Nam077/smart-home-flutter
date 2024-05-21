import 'room.dart';
import 'unit.dart';

class Device {
  int? id;
  String name;
  String description;
  bool status;
  String pinMode;
  int value;
  String image;
  Room? room;
  Unit? unit;
  bool isSensor;
  int? unitId;
  int? roomId;

  Device({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.pinMode,
    required this.value,
    required this.image,
    this.room,
    this.unit,
    required this.isSensor,
    this.unitId,
    this.roomId,
  });

  Device.empty()
      : id = null,
        name = '',
        description = '',
        status = false,
        pinMode = '',
        value = 0,
        image = '',
        room = null,
        unit = null,
        isSensor = false,
        unitId = null,
        roomId = null;

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      pinMode: json['pinMode'],
      value: json['value'],
      image: json['image'],
      room: json['room'] != null ? Room.fromJson(json['room']) : null,
      unit: json['unit'] != null ? Unit.fromJson(json['unit']) : null,
      isSensor: json['isSensor'],
      unitId: json['unitId'],
      roomId: json['roomId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'pinMode': pinMode,
      'value': value,
      'image': image,
      'room': room?.toJson(),
      'unit': unit?.toJson(),
      'isSensor': isSensor,
      'unitId': unitId,
      'roomId': roomId,
    };
  }
}
