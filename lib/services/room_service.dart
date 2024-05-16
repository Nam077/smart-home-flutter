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
}
