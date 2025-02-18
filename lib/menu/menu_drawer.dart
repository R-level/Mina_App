import 'package:flutter/material.dart';
import 'package:mina_app/screens/home.dart';
import 'package:mina_app/screens/second_page.dart';
import 'package:mina_app/screens/third_page.dart';
import 'package:mina_app/screens/fourth_page.dart';
class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
     child:ListView(
       children: [
       const DrawerHeader(child: Text('Hello'),
       ),
       ListTile(
         title: const Text("Home Page"),
         onTap: () {
          Navigator.pop(context);
           Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
         },
       ),
        ListTile(
         title: const Text("Second Page"),
         onTap: () {
           Navigator.pop(context);
           Navigator.push(context, MaterialPageRoute(builder: (context) => const SecondPage()));
         },
       ),ListTile(
         title: const Text("Third Page"),
         onTap: () {
           Navigator.pop(context);
           Navigator.push(context, MaterialPageRoute(builder: (context) => const ThirdPage()));
         },
       ),ListTile(
         title: const Text("Fourth Page"),
         onTap: () {
           Navigator.pop(context);
           Navigator.push(context, MaterialPageRoute(builder: (context) => const FourthPage()));
         },
       ),
     ])
    );
  }
}
