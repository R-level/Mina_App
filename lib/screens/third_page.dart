import 'package:flutter/material.dart';
import 'package:mina_app/menu/menu_drawer.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.green,
      drawer: const MenuDrawer(),
      appBar: AppBar(
        title: const Text('My App'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
                child: Text('Hello, This is the third page!'),
      ),
    );
  }
}