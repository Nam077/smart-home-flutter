import 'package:flutter/material.dart';

import '../../models/device.dart';

class DeviceCard extends StatefulWidget {
  final Device device;
  const DeviceCard({super.key, required this.device});

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  bool _deviceStatus = false;

  @override
  void initState() {
    super.initState();
    _deviceStatus = widget.device.status; // Khởi tạo trạng thái ban đầu
  }

  void _handleSwitchChanged(bool newValue) {
    setState(() {
      _deviceStatus = newValue; // Cập nhật trạng thái và xây dựng lại UI
    });
  }

  @override
  Widget build(BuildContext context) {
    // Thiết lập màu nền và màu chữ dựa trên trạng thái 3A81F7 và F5F5F5
    Color backgroundColor =
        _deviceStatus ? const Color(0xFF3A81F7) : const Color(0xFFFFFFFF);
    Color textColor = _deviceStatus ? Colors.white : const Color(0xFF65739E);

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: backgroundColor, // Áp dụng màu nền ở đây
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: _deviceStatus ? Colors.black12 : Colors.transparent,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      _handleSwitchChanged(!_deviceStatus);
                    },
                    child: Image.network(widget.device.image,
                        width: 60, height: 60),
                  ),
                  Transform.scale(
                      scale: 0.9,
                      child: Switch(
                        value: _deviceStatus,
                        onChanged: _handleSwitchChanged,
                        activeColor: const Color(0xFFFFFFFF),
                      )),
                ],
              ),
              const SizedBox(height: 40),
              Divider(
                color: _deviceStatus ? Colors.white : Colors.black12,
                thickness: 0.6,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.device.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: textColor, // Áp dụng màu chữ ở đây
                      ),
                    ),
                    Text(
                      widget.device.room!.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor, // Áp dụng màu chữ ở đây
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
