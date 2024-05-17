import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smarthome/views/screens/add_unit.dart';

// Các màn hình khác nhau
import 'package:smarthome/views/screens/home_page.dart';
import 'package:smarthome/views/screens/add_device.dart';

import 'views/screens/add_room.dart';
import 'views/screens/test.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: null, // Đặt màu nền của NavigationBar
          height: 70, // Đặt chiều cao của NavigationBar
          indicatorColor: Colors.amber,
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Danh sách các widget cho mỗi trang
  final List<Widget> _pages = [
    const HomePage(),
    const AddDevice(),
    const AddRoom(),
    const AddUnit(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FF),
      body: SafeArea(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          NavigationDestination(
            icon: Icon(Icons.devices_other),
            label: 'Thêm thiết bị',
          ),
          NavigationDestination(
            icon: Icon(Icons.room_sharp),
            label: 'Thêm phòng',
          ),
          NavigationDestination(
            icon: Icon(Icons.add),
            label: 'Thêm đơn vị',
          ),
        ],
      ),
    );
  }
}
