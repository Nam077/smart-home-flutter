import 'package:flutter_dotenv/flutter_dotenv.dart';
// call api to get room
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:smarthome/models/room.dart';

class RoomService {
  static Future<List<Room>> getRooms() async {
    final header = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };
    final response = await http
        .get(Uri.parse('${dotenv.env['API_SERVER']}/room'), headers: header);
    if (response.statusCode == 200) {
      final List<dynamic> rooms = convert.jsonDecode(response.body);
      return rooms.map((json) => Room.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load rooms');
    }
  }

  static Future<String> addRoom(String name, String description) async {
    final header = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
    };
    final response = await http.post(
      Uri.parse('${dotenv.env['API_SERVER']}/room'),
      headers: header,
      body: convert.jsonEncode(<String, String>{
        'name': name,
        'description': description,
      }),
    );
    if (response.statusCode == 201) {
      final Map<String, dynamic> body = convert.jsonDecode(response.body);
      return "Room ${body['name']} added successfully";
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
        throw Exception('Failed to add room');
      }
    }
  }
}
