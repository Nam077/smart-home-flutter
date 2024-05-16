import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0), // Margin giữa các header
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Màu nền
        borderRadius: BorderRadius.circular(15), // Border radius
        boxShadow: const [
          BoxShadow(
            color: Colors.black12, // Màu shadow
            blurRadius: 10, // Độ mờ của shadow
            offset: Offset(0, 5), // Độ lệch của shadow
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade300, // Màu border
          width: 1, // Độ dày của border
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Home',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Hey, welcome back!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          CircleAvatar(
            backgroundImage: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/7733/7733361.png'), // Thay bằng URL ảnh profile của bạn
          ),
        ],
      ),
    );
  }
}
