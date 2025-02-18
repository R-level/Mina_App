import 'package:flutter/material.dart';
import 'package:mina_app/menu/menu_drawer.dart';
import 'package:mina_app/database/DatabaseHelper.dart';
import 'package:mina_app/model/user.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({super.key});

  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    final dbHelper = DatabaseHelper();
    final user = await dbHelper.getUser('123'); // Replace '123' with the actual userId
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent,
      drawer: const MenuDrawer(),
      appBar: AppBar(
        title: const Text('My App'),
      ),
      body: Center(
        child: _user == null
            ? const CircularProgressIndicator()
            : Text('Hello, ${_user!.name}! This is the Fourth page!'),
      ),
    );
  }
}