import 'package:flutter/material.dart';
import './view/crear_persona_page.dart';
import './view/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarea 2.2',
      home: HomePage(),
    );
  }
}

