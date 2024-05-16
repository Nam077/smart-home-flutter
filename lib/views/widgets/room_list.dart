import 'package:flutter/material.dart';
import '../../models/room.dart';

class RoomList extends StatelessWidget {
  final List<Room> rooms;

  const RoomList({super.key, required this.rooms});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection:
            Axis.horizontal, // Thiết lập scrollDirection thành ngang
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          return Container(
            width: 100,
            height: 50,
            margin: const EdgeInsets.symmetric(
                horizontal: 5), // Thêm khoảng cách giữa các phần tử
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                room.name,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
