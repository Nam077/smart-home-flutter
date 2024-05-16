import 'package:flutter/material.dart';

import '../../models/room.dart';

class RoomTabs extends StatefulWidget {
  final List<Room> rooms;
  final int currentRoomId;
  const RoomTabs(
      {super.key,
      required this.rooms,
      required this.onTabSelected,
      required this.currentRoomId});
  final Function(int) onTabSelected;

  @override
  State<RoomTabs> createState() => _RoomTabsState();
}

class _RoomTabsState extends State<RoomTabs> {
  int _selectedId = 0;
  void _onTabSelected(int id) {
    setState(() {
      _selectedId = id;
      widget.onTabSelected(id);
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedId = widget.currentRoomId;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.rooms.length,
        clipBehavior: Clip.none, // Thêm dòng này để không cắt shadow
        itemBuilder: (context, index) {
          final room = widget.rooms[index];
          final bool isSelected = room.id == _selectedId;
          return GestureDetector(
            onTap: () => _onTabSelected(room.id),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12, // Màu shadow
                    blurRadius: 10, // Độ mờ của shadow
                    offset: Offset(0, 5), // Độ lệch của shadow
                  ),
                ],
                color: isSelected ? Colors.blueAccent : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.blueAccent : Colors.grey,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  room.name,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
