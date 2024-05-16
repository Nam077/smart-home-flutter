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

  static Future<void> updateDeviceStatus(int id) async {
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
  }
}
