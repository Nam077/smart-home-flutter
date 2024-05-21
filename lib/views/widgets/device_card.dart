import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smarthome/services/device_service.dart';

import '../../models/device.dart';

class DeviceCard extends StatefulWidget {
  final Device device;
  final Future<bool> Function(int id, bool status) onToggle;
  const DeviceCard({super.key, required this.device, required this.onToggle});

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  Device _device = Device.empty();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _device = widget.device;
    if (_device.isSensor) {
      startTimer();
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    final device = await DeviceService.getDeviceById(_device.id!);
    if (mounted) {
      setState(() {
        _device = device;
      });
    }
  }

  void _handleSwitchChanged(bool newValue) {
    if (_device.isSensor) {
      return;
    }
    widget.onToggle(_device.id!, newValue).then((value) {
      if (value) {
        setState(() {
          _device.status = newValue;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor =
        _device.status ? const Color(0xFF3A81F7) : const Color(0xFFFFFFFF);
    Color textColor = _device.status ? Colors.white : const Color(0xFF65739E);

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: backgroundColor, // Áp dụng màu nền ở đây
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: _device.status ? Colors.black12 : Colors.transparent,
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
                      _handleSwitchChanged(!_device.status);
                    },
                    child: Image.network(_device.image, width: 60, height: 60),
                  ),
                  _device.isSensor
                      ? Text(
                          '${_device.value} ${_device.unit?.abbreviation ?? ''}',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Transform.scale(
                          scale: 0.9,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors
                                    .transparent, // Màu viền trong suốt để loại bỏ viền
                              ),
                              borderRadius: BorderRadius.circular(
                                  20.0), // Bán kính viền để tạo hiệu ứng cong
                            ),
                            child: Switch(
                              value: _device.status,
                              onChanged: _handleSwitchChanged,
                              activeColor: const Color(0xFFFFFFFF),
                              // Màu thumb khi không bật
                            ),
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 40),
              Divider(
                color: _device.status ? Colors.white : Colors.black12,
                thickness: 0.6,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _device.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: textColor, // Áp dụng màu chữ ở đây
                      ),
                    ),
                    Text(
                      _device.room!.name,
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
