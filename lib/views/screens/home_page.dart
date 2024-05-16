import 'package:flutter/material.dart';
import 'package:smarthome/models/device.dart';
import 'package:smarthome/services/device_service.dart';
import 'package:smarthome/services/room_service.dart';

import '../../models/room.dart';
import '../widgets/header.dart';
import '../widgets/list_device_card.dart';
import '../widgets/room_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Room>> futureRooms;
  late Future<List<Device>> futureDevices;
  int _selectedRoomId = -1;

  @override
  void initState() {
    super.initState();
    futureDevices = Future.value([]);
    _fetchRooms();
  }

  void _fetchDevices(int id) async {
    setState(() {
      futureDevices = DeviceService.getDeviceByIdRomm(id);
    });
  }

  void _fetchRooms() {
    futureRooms = RoomService.getRooms();
    futureRooms.then((rooms) {
      if (rooms.isNotEmpty) {
        if (_selectedRoomId == -1) {
          _selectedRoomId = rooms.first.id;
        }
        _fetchDevices(_selectedRoomId);
      }
    }).catchError((error) {});
    setState(() {});
  }

  void _onRefresh() {
    _fetchRooms();
  }

  void onToggle(int index, bool status) {}

  void _onTabSelected(int id) {
    if (id != _selectedRoomId) {
      _fetchDevices(id);
    }
    setState(() {
      _selectedRoomId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FF),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _onRefresh();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Header(),
                  FutureBuilder(
                      future: futureRooms,
                      builder: (context, snapshot) {
                        return _buildRoomList(context, snapshot);
                      }),
                  const SizedBox(height: 16),
                  const Text(
                    'Devices',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder(
                      future: futureDevices,
                      builder: (context, snapshot) {
                        return _buildDeviceList(context, snapshot);
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoomList(
      BuildContext context, AsyncSnapshot<List<Room>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Text('No rooms available');
    }
    return RoomTabs(
        rooms: snapshot.data!,
        onTabSelected: _onTabSelected,
        currentRoomId: _selectedRoomId);
  }

  Widget _buildDeviceList(
      BuildContext context, AsyncSnapshot<List<Device>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Text('No devices available');
    }
    return ListDeviceCard(devices: snapshot.data!);
  }
}
