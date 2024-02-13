import 'package:flutter/material.dart';
import 'package:v2rayclient/screens/Home/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Khalil Vpn',
      home: HomeScreen(),
    );
  }
}
