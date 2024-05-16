import 'package:flutter/material.dart';

import '../../models/device.dart';
import 'device_card.dart';

class ListDeviceCard extends StatelessWidget {
  final List<Device> devices; // Danh sách các thiết bị
  final Future<bool> Function(int id, bool status)
      onToggle; // Hàm xử lý khi bật/tắt thiết bị
  const ListDeviceCard(
      {super.key, required this.devices, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context)
          .size
          .height, // Or any other logical height based on your UI design
      child: GridView.builder(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(), // Essential to prevent scrolling within the grid
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.8,
        ),
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return DeviceCard(device: devices[index], onToggle: onToggle);
        },
      ),
    );
  }
}
