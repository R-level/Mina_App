import 'package:flutter/material.dart';
import 'package:mina_app/menu/menu_drawer.dart';
import 'package:table_calendar/table_calendar.dart';

class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
       
        
        
      ),
      body:  Center(
        child:  Column(children: [
          const Text('Hello, This is the Home page!'),
          const Text('Choose an item from the menu!'),
          TableCalendar(

                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: DateTime.now(),
                  calendarFormat: CalendarFormat.week,
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                  ),
                ),
                const SizedBox(height: 20),
                const Text('You have not selected a date.')
          ]
                ,),
              
               
      ),
      
     drawer: const MenuDrawer(),
     );
  }
}
