import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mina_app/features/widgets/common/menu/menu_drawer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mina_app/features/day_entry/view/day_entry_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mina_app/features/dashboard/bloc/dashboard_bloc.dart';
import 'package:mina_app/data/repositories/cycle_repository.dart';
import 'package:mina_app/data/repositories/day_entry_repository.dart';
import 'package:mina_app/data/model/day.dart';
import 'package:intl/intl.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _events = {};
  List<Day> periodDays = [];
  Set<dynamic> periodDayDatesSet = {};

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _loadEventsFromDatabase();
  }

  Future<void> _loadEventsFromDatabase() async {
    try {
      // Get the current month's range
      final DateTime firstDayOfMonth = DateTime(
        _focusedDay.year,
        _focusedDay.month,
        1,
      );
      final DateTime lastDayOfMonth = DateTime(
        _focusedDay.year,
        _focusedDay.month + 1,
        0,
      );

      // Fetch period days from repository
      periodDays = await DayEntryRepository.instance
          .getPeriodDaysInRange(firstDayOfMonth, lastDayOfMonth);

      // Convert to set of DateTimes
      Set<dynamic> periodSet =
          periodDays.map((day) => normalizeDate(day.date)).toSet();

      // Update state with new events
      setState(() {
        // _events = newEvents;
        periodDayDatesSet = periodSet;
      });
    } catch (e) {
      debugPrint('Error loading events: $e');
      // Optionally show an error message to the user
      /* if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load period days'),
            backgroundColor: Colors.red,
          ),
        );
      } */
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(
        cycleRepository: CycleRepository(),
      )..add(LoadDashboard()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mina'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<DashboardBloc>().add(RefreshDashboard());
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromARGB(55, 227, 183, 235),
                Color.fromARGB(55, 233, 30, 98)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
            height: double.infinity,
            width: double.infinity,
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
                      Flexible(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(120, 250, 238, 249),
                          ),
                          height: double.infinity,
                          width: double.infinity,
                          child: TableCalendar(
                            firstDay: DateTime.utc(1670, 1, 1),
                            lastDay:
                                DateTime.utc(DateTime.now().year + 10, 12, 31),
                            focusedDay: _focusedDay,
                            selectedDayPredicate: (day) =>
                                isSameDay(_selectedDay, day),
                            calendarFormat: CalendarFormat.month,
                            headerStyle: const HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                            ),
                            onDaySelected: (selectedDay, focusedDay) async {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                              final result = await Navigator.of(context).push(
                                  _createRoute(normalizeDate(_focusedDay)));

                              if (result == true) {
                                _loadEventsFromDatabase();
                                //context.read<DashboardBloc>().add(RefreshDashboard());
                              }
                            },
                            onPageChanged: (focusedDay) {
                              //Change the focused day and reload days from the
                              //database
                              setState(() {
                                _focusedDay = focusedDay;
                              });
                              _loadEventsFromDatabase();
                            },
                            //eventLoader: _getEventsForDay,
                            calendarBuilders: CalendarBuilders(
                              prioritizedBuilder: (context, day, focusedDay) {
                                var isPeriodDay = periodDayDatesSet
                                    .contains(normalizeDate(day));

                                return Container(
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: isPeriodDay
                                        ? Color.fromARGB(120, 244, 67, 54)
                                        : null,
                                    shape: BoxShape.circle,
                                    border: normalizeDate(day) ==
                                            normalizeDate(DateTime.now())
                                        ? Border.all(
                                            color: const Color.fromARGB(
                                                255, 54, 111, 244),
                                            width: 2,
                                          )
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${day.day}',
                                      style: TextStyle(
                                        color: isPeriodDay
                                            ? Colors.white
                                            : Colors.black,
                                        // isPeriodDay ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            calendarStyle: CalendarStyle(
                              withinRangeDecoration: const BoxDecoration(
                                color: Color.fromARGB(116, 255, 102, 199),
                                shape: BoxShape.circle,
                              ),
                              selectedTextStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              rangeHighlightColor:
                                  const Color.fromARGB(124, 255, 102, 224),
                              markerDecoration: const BoxDecoration(
                                color: null,
                                shape: BoxShape.circle,
                              ),
                              todayDecoration: periodDayDatesSet
                                      .contains(normalizeDate(DateTime.now()))
                                  ? BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    )
                                  : BoxDecoration(
                                      color: Color.fromARGB(180, 33, 149, 243),
                                      shape: BoxShape.circle,
                                    ),
                              selectedDecoration: const BoxDecoration(
                                color: Color.fromARGB(0, 76, 175, 79),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: 20,
                          child: Container(
                              decoration: BoxDecoration(
                            color: Color.fromARGB(120, 250, 238, 249),
                          ))),

                      // Menstrual Information Sections
                      Flexible(
                        child: ListView(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
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
                                      title: const Text(
                                          "Understanding Your Cycle"),
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
                              description:
                                  "Tips for maintaining menstrual health.",
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
                              description:
                                  "Explore common symptoms and remedies.",
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
        ),
        drawer: const MenuDrawer(),
      ),
    );
  }

  //method to normalize DateTime objects in a list
  DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
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
      pageBuilder: (context, animation, secondaryAnimation) {
        return FutureBuilder<Day?>(
            future: DayEntryRepository.instance.getDayEntry(focusedDay),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Scaffold(
                  body: Center(child: Text('Error: ${snapshot.error}')),
                );
              }
              if (snapshot.hasData) {
                return DayEntryView(
                  focusedDay: focusedDay,
                  existingDay: snapshot.data,
                );
              }
              return DayEntryView(focusedDay: focusedDay);
            });
      },
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
