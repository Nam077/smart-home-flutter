import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/device.dart';
import '../../services/device_service.dart';
import '../widgets/list_device_card.dart';
import 'home_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late Future<List<Device>> devicesFuture;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    devicesFuture = DeviceService.getDeviceByIdRomm(1);
  }

  void _refresh() {
    setState(() {
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Device List')),
        body: RefreshIndicator(
          onRefresh: () async {
            _refresh();
          },
          child: FutureBuilder<List<Device>>(
            future: devicesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('No devices found.'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _refresh,
                        child: const Text('Refresh'),
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Rooms',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListDeviceCard(devices: snapshot.data!),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              } else {
                return const Center(
                  child: Text('Unexpected error occurred.'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
