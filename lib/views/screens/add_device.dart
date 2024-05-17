import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smarthome/models/device.dart';
import 'package:smarthome/services/device_service.dart';
import 'package:smarthome/services/room_service.dart';
import 'package:smarthome/services/unit_service.dart';
import '../../models/room.dart';
import '../../models/unit.dart';
import '../widgets/room_dropdown.dart';
import '../widgets/unit_dropdown.dart';

class AddDevice extends StatefulWidget {
  const AddDevice({super.key});
  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  late List<Room> rooms = [];
  late List<Unit> units = [];
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  String _image = '';
  String _pinMode = '';
  int _value = 0;
  int _roomId = 0;
  int _unitId = 0;
  bool _status = false;
  bool _isSensor = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _pinModeController = TextEditingController();

  void _initializeDefaultValues() {
    _nameController.text = '';
    _descriptionController.text = '';
    _imageController.text =
        'https://cdn-icons-png.flaticon.com/512/979/979619.png';
    _pinModeController.text = '';
  }

  @override
  void initState() {
    super.initState();
    _fetchRooms();
    _fetchUnits();
    _initializeDefaultValues();
  }

  void _showToastError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _fetchRooms() async {
    try {
      final rooms = await RoomService.getRooms();
      setState(() {
        if (rooms.isNotEmpty) {
          _roomId = rooms.first.id;
        }
        this.rooms = rooms;
      });
    } catch (e) {
      _showToastError('Có lỗi xảy ra khi lấy dữ liệu phòng');
    }
  }

  Future<void> _fetchUnits() async {
    try {
      final units = await UnitService.getUnits();
      setState(() {
        if (units.isNotEmpty) {
          _unitId = units.first.id;
        }
        this.units = units;
      });
    } catch (e) {
      _showToastError('Có lỗi xảy ra khi lấy dữ liệu đơn vị');
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        Device device = Device(
          name: _name,
          description: _description,
          image: _image,
          pinMode: _pinMode,
          roomId: _roomId,
          unitId: _unitId,
          status: _status,
          isSensor: _isSensor,
          value: _value,
          id: null,
        );
        String message = await DeviceService.addDevice(device);
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        _formKey.currentState!.reset();
      } catch (error) {
        Fluttertoast.showToast(
          msg: error.toString().replaceFirst('Exception: ', ''),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  void _onChangedUnit(Unit? unit) {
    setState(() {
      _unitId = unit?.id ?? 0;
    });
  }

  void _onChangedRoom(Room? room) {
    setState(() {
      _roomId = room?.id ?? 0;
    });
  }

  Future<void> _onRefresh() async {
    _fetchRooms();
    _fetchUnits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Device'),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Tên thiết bị',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tên thiết bị';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),

                const SizedBox(height: 10),

                // Pin mode field
                const Text(
                  'Pin Mode',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập pin mode';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _pinMode = value!;
                  },
                ),

                const SizedBox(height: 10),

                // Image field
                const Text(
                  'Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _imageController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập link ảnh';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _image = value!;
                  },
                ),

                const SizedBox(height: 10),

                // Room Id dropdown
                const Text(
                  'Phòng',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                RoomDropdown(onChanged: _onChangedRoom, rooms: rooms),

                const SizedBox(height: 10),

                const SizedBox(height: 10),

                // Description field
                const Text(
                  'Mô tả',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mô tả';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),

                const SizedBox(height: 20),

                // Status switch
                SwitchListTile(
                  title: const Text(
                    'Trạng thái',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  value: _status,
                  onChanged: (bool value) {
                    setState(() {
                      _status = value;
                    });
                  },
                ),

                const SizedBox(height: 10),

                // Is Sensor switch
                SwitchListTile(
                  title: const Text(
                    'Là cảm biến',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  value: _isSensor,
                  onChanged: (bool value) {
                    setState(() {
                      _isSensor = value;
                    });
                  },
                ),
                _isSensor
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Unit Id dropdown
                          const Text(
                            'Đơn vị',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          UnitDropdown(onChanged: _onChangedUnit, units: units),
                          const SizedBox(height: 10),
                          // Value field
                          const Text(
                            'Giá trị',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),

                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _value = int.parse(value!);
                            },
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A81F7),
                    ),
                    child: const Text(
                      'Thêm thiết bị',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
