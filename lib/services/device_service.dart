import 'package:flutter_dotenv/flutter_dotenv.dart';
// call api to get room
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:smarthome/models/device.dart';

class DeviceService {
  static Future<List<Device>> getDeviceByIdRomm(int id) async {
    final header = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };
    final response = await http.get(
        Uri.parse('${dotenv.env['API_SERVER']}/device/room/$id'),
        headers: header);
    if (response.statusCode == 200) {
      final List<dynamic> devices = convert.jsonDecode(response.body);
      return devices.map((json) => Device.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load devices');
    }
  }

  static Future<bool> updateDeviceStatus(int id) async {
    final header = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };
    final response = await http.patch(
      Uri.parse('${dotenv.env['API_SERVER']}/device/status/$id'),
      headers: header,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update device status');
    }
    return response.statusCode == 200;
  }

  static Future<String> textHandler(String text) async {
    final header = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };
    final response = await http.patch(
      Uri.parse('${dotenv.env['API_SERVER']}/device/text'),
      headers: header,
      body: convert.jsonEncode({'text': text}),
    );
    if (response.statusCode == 200) {
      final result = convert.jsonDecode(response.body);
      return result['message'];
    } else {
      throw Exception('Failed to handle text');
    }
  }

  static Future<Device> getDeviceById(int id) async {
    final header = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };
    final response = await http.get(
      Uri.parse('${dotenv.env['API_SERVER']}/device/$id'),
      headers: header,
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> device = convert.jsonDecode(response.body);
      return Device.fromJson(device);
    } else {
      throw Exception('Failed to load device');
    }
  }

  static Future<String> addDevice(Device device) async {
    final header = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };
    final response = await http.post(
      Uri.parse('${dotenv.env['API_SERVER']}/device'),
      headers: header,
      body: convert.jsonEncode({
        'name': device.name,
        'status': device.isSensor ? false : device.status,
        'isSensor': device.isSensor,
        'image': device.image,
        'pinMode': device.pinMode,
        'value': device.value,
        'description': device.description,
        'roomId': device.roomId,
        'unitId': device.isSensor ? device.unitId : null,
      }),
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> body = convert.jsonDecode(response.body);
      return "Device ${body['name']} added successfully";
    } else {
      final Map<String, dynamic> body = convert.jsonDecode(response.body);
      if (body.containsKey('message')) {
        if (body['message'] is List) {
          throw Exception(body['message']
              .join('\n')
              .toString()
              .replaceFirst('Exception: ', ''));
        } else {
          throw Exception(body['message']);
        }
      } else {
        throw Exception('Failed to add device');
      }
    }
  }
}
