import 'package:flutter/material.dart';
import 'package:smarthome/models/device.dart';
import 'package:smarthome/services/device_service.dart';
import 'package:smarthome/services/room_service.dart';
import 'package:smarthome/views/widgets/modal_sptt.dart';

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

  void showToastError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const ModalSpeechToText(); // Your StatefulWidget inside the modal
      },
    );
  }

  void _fetchDevices(int id) async {
    try {
      setState(() {
        futureDevices = DeviceService.getDeviceByIdRomm(id);
      });
    } catch (e) {
      showToastError('Có lỗi xảy ra khi lấy dữ liệu thiết bị');
    }
  }

  void _fetchRooms() {
    try {
      futureRooms = RoomService.getRooms();
      futureRooms.then((rooms) {
        if (rooms.isNotEmpty) {
          if (_selectedRoomId == -1) {
            _selectedRoomId = rooms.first.id;
          }
          _fetchDevices(_selectedRoomId);
        }
      }).catchError((error) {
        // Handle the error, e.g., show a message to the user
        showToastError('Có lỗi xảy ra khi lấy dữ liệu phòng');
      });
      setState(() {});
    } catch (e) {
      // Handle the error, e.g., show a message to the user
      showToastError('Có lỗi xảy ra khi lấy dữ liệu phòng');
    }
  }

  void _onRefresh() {
    try {
      _fetchRooms();
    } catch (e) {
      // Handle the error, e.g., show a message to the user
      showToastError('Có lỗi xảy ra khi làm mới dữ liệu');
    }
  }

  Future<bool> onToggleAPI(int id, bool status) async {
    try {
      bool result = await DeviceService.updateDeviceStatus(id);
      return result;
    } catch (e) {
      showToastError('Có lỗi xảy ra khi cập nhật trạng thái thiết bị');
      return false;
    }
  }

  Future<bool> onToggle(int id, bool status) async {
    try {
      bool result = await onToggleAPI(id, status);
      return result;
    } catch (e) {
      // Handle the error, e.g., show a message to the user
      showToastError('Có lỗi xảy ra khi cập nhật trạng thái thiết bị');
      return false;
    }
  }

  void _onTabSelected(int id) {
    try {
      if (id != _selectedRoomId) {
        _fetchDevices(id);
      }
      setState(() {
        _selectedRoomId = id;
      });
    } catch (e) {
      // Handle the error, e.g., show a message to the user
      showToastError('Có lỗi xảy ra khi chọn phòng');
    }
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
        floatingActionButton: FloatingActionButton(
          // icon micro
          child: const Icon(Icons.mic),
          onPressed: () {
            _showModal(context);
          },
        ));
  }

  Widget _buildRoomList(
      BuildContext context, AsyncSnapshot<List<Room>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
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
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Text('No devices available');
    }
    return ListDeviceCard(devices: snapshot.data!, onToggle: onToggle);
  }
}
