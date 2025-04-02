import 'package:flutter/material.dart';
import 'package:mina_app/features/widgets/common/menu/menu_drawer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mina_app/features/day_entry/view/day_entry_view.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        
        child: Column(
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(178, 132, 77, 151),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome to My Mina!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Track your days and stay organized.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
        
            // Calendar Section
            Flexible(
              
              child: Column(
                
                mainAxisSize: MainAxisSize.min,
                
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    calendarFormat: CalendarFormat.month,
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      Navigator.of(context).push(_createRoute(_focusedDay));
                    },
                    calendarStyle: const CalendarStyle(
                      withinRangeDecoration: BoxDecoration(
                          color: Color.fromARGB(116, 255, 102, 199),
                          shape: BoxShape.circle),
                      rangeHighlightColor: Color.fromARGB(124, 255, 102, 224),
                    ),
                  ),
                  const SizedBox(height: 20),
        
                  // Menstrual Information Sections
                  Flexible(
                    
                    child: ListView(
                      children: [
                        _buildInfoSection(
                          context,
                          title: "Understanding Your Cycle",
                          description:
                              "Learn about the phases of your menstrual cycle.",
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Understanding Your Cycle"),
                                  content: const Text(
                                    "The menstrual cycle has four phases: menstrual, follicular, ovulation, and luteal. "
                                    "Each phase plays a vital role in your reproductive health.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text("Close"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        _buildInfoSection(
                          context,
                          title: "Healthy Habits",
                          description: "Tips for maintaining menstrual health.",
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Healthy Habits"),
                                  content: const Text(
                                    "Maintain a balanced diet, stay hydrated, exercise regularly, and get enough sleep "
                                    "to support your menstrual health.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text("Close"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        _buildInfoSection(
                          context,
                          title: "Common Symptoms",
                          description: "Explore common symptoms and remedies.",
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Common Symptoms"),
                                  content: const Text(
                                    "Common menstrual symptoms include cramps, bloating, mood swings, and fatigue. "
                                    "Remedies include pain relievers, heat therapy, and relaxation techniques.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text("Close"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: const MenuDrawer(),
    );
  }

  Widget _buildInfoSection(BuildContext context,
      {required String title,
      required String description,
      required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Route _createRoute(DateTime focusedDay) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          DayEntryView(focusedDay: focusedDay),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
