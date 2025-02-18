import 'package:flutter/material.dart';
import 'package:mina_app/menu/menu_drawer.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.red,
      drawer: const MenuDrawer(),
      appBar: AppBar(
        title: const Text('My App'),
        backgroundColor: Colors.red,
      ),
      body: const Center(
                child: Text('Hello, This is the Second page!'),
      ),
    );
  }
}