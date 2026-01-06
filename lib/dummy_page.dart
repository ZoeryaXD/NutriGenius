import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Belum ada notifikasi",
          style: TextStyle(color: Colors.green, fontSize: 18),
        ),
      ),
    );
  }
}
