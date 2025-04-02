import 'package:flutter/material.dart';
import 'package:mina_app/features/dashboard/view/dashboard_view.dart';
import 'package:mina_app/features/feedback/view/feedback_view.dart';
class MenuDrawer extends StatelessWidget {
  const MenuDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
     child:ListView(
       children: [
        const DrawerHeader(
          
          decoration: BoxDecoration(
            color: Color.fromARGB(178, 132, 77, 151), // Optional: Add a background color
          ),
          child: Text(
            'My Mina',
            style: TextStyle(
              fontSize: 24, // Increased font size
              fontWeight: FontWeight.bold, // Optional: Make it bold
              color: Colors.white, // Optional: Change text color
            ),
          ),
        ),
       ListTile(
         title: const Text("Home Page"),
         onTap: () {
          Navigator.pop(context);
           Navigator.push(context, MaterialPageRoute(builder: (context) =>  Home()));
         },
       ),
       ListTile(
         title: const Text("Feedback"),
         onTap: () {
           Navigator.pop(context);
           Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackView()));
         },
       ) /*,ListTile(
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
     */])
    );
  }
}
