import 'package:flutter_dotenv/flutter_dotenv.dart';
// call api to get room
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:smarthome/models/device.dart';
import 'package:smarthome/models/unit.dart';

class UnitService {
  static Future<List<Unit>> getUnits() async {
    final header = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };
    final response = await http
        .get(Uri.parse('${dotenv.env['API_SERVER']}/unit'), headers: header);
    if (response.statusCode == 200) {
      final List<dynamic> units = convert.jsonDecode(response.body);
      return units.map((json) => Unit.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load units');
    }
  }

  static Future<String> addUnit(Unit unit) async {
    final header = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };
    final response = await http.post(
      Uri.parse('${dotenv.env['API_SERVER']}/unit'),
      headers: header,
      body: convert.jsonEncode(<String, String>{
        'name': unit.name,
        'abbreviation': unit.abbreviation,
      }),
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> body = convert.jsonDecode(response.body);
      return "Unit ${body['name']} added successfully";
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
        throw Exception('Failed to add unit');
      }
    }
  }
}
