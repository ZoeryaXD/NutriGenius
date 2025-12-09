import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: HelloWorldScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class HelloWorldScreen extends StatelessWidget {
  const HelloWorldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hello World")),
      body: const Center(
        child: Text(
          "Hello World",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
