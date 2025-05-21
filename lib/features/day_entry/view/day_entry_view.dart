import 'package:flutter/material.dart';
import 'package:mina_app/data/model/day.dart';
import 'package:mina_app/data/model/period_day.dart';
import 'package:mina_app/data/model/mood_list.dart';
import 'package:mina_app/data/model/symptom_list.dart';
import 'package:mina_app/data/repositories/day_entry_repository.dart';
import 'package:mina_app/features/day_entry/bloc/day_entry_bloc.dart';
import 'package:mina_app/features/period/period_day_picker_view.dart';

class DayEntryView extends StatefulWidget {
  const DayEntryView({super.key, required this.focusedDay, this.existingDay});
  final DateTime focusedDay;
  final Day? existingDay; // Optional existing day entry

  @override
  State<DayEntryView> createState() => _DayEntryViewState();
}

class _DayEntryViewState extends State<DayEntryView> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedFlow;
  bool _isPeriodDaySelected = false; // Track if "Is Period Day" is selected
  final List<String> _selectedSymptoms = [];
  final List<String> _selectedMoods = [];
  final TextEditingController _notesController = TextEditingController();
  bool _isPeriodStartDay = false;
  bool _isPeriodEndDay = false;

  @override
  void initState() {
    super.initState();

    // Populate fields if an existing day is provided
    if (widget.existingDay != null) {
      final day = widget.existingDay!;
      _isPeriodDaySelected = day.isPeriodDay;
      //Check if the day is a PeriodDay and cast it
      if (day is PeriodDay) {
        _selectedFlow = day.flowWeight.index.toString();
        _isPeriodStartDay = day.isPeriodStartDay;
        _isPeriodEndDay = day.isPeriodEndDay;
      }

      if (day.symptomList != null) {
        _selectedSymptoms.addAll(day.symptomList!.symptoms);
      }
      if (day.moodList != null) {
        _selectedMoods.addAll(day.moodList!.moods);
      }
      _notesController.text = day.note ?? "";
    } else {
      // Initialize fields as empty for a new day entry
      _selectedFlow = '0';
      _selectedSymptoms.clear();
      _selectedMoods.clear();
      _notesController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        /* appBar: AppBar(
            title: const Text("Day Entry"),
          ), */
        body: Container(
          padding: const EdgeInsets.only(top: 16.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(55, 225, 194, 230),
                Color.fromARGB(55, 241, 188, 206)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* 
                  UI should change to reflect the current state of the app
                  at any given time.
                  If it's a period day, it should show the period day UI
                  If it's not a period day, it should show the regular day UI
                  
                  Global Menstrual Cyclestate is determined whether a PeriodisStartDay has passed or a PeriodisEndDay has passed has been selected
                  The idea would be to display the period day UI when the period is in the middle of the cycle and the regular day UI when the period is not in the middle of the cycle
                  Also historical records that are not period days will not have the ability to change to a period day.
                  A period day will have the ability to change to a regular day.
                  In this use case the user is presented with a calendar view of days with the ability to mark a day as a period day.
                  The calendar view will show period days and regular days, and allow the user to mark any day as a period day.
                  Once saved the app records the days that were marked as period days and processes any changes made.
                  This process involves saving the changes to the database and updating the UI to reflect the changes.
                  Changes most likely will include updating a day to a period day and vice-versa.
                  Consecutive period days are grouped. The first and last of the period days are marked as special.
                  Why are these days special? It's to help with calculating the days that are in a period.
                  The average length 
                  */

                  const Text('Is it a Period Day?',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Text(
                    "Tracking for: ${widget.focusedDay.toLocal()}"
                        .split(' ')[0],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(children: [
                    /* Switch(
                      value: _isPeriodDaySelected,
                      onChanged: (value) {
                        setState(() {
                          _isPeriodDaySelected = value;
                        });
                      },
                    ) */
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => PeriodDayPickerView(
                                  focusedDay: widget.focusedDay)),
                        );
                      },
                      child: Text("Period Day Picker"),
                    )
                  ]),
                  const SizedBox(height: 20),

                  // Flow Intensity Section
                  const Text("Flow Intensity",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: "0", label: Text("None")),
                      ButtonSegment(value: "1", label: Text("Light")),
                      ButtonSegment(
                        value: "2",
                        label: Text("Medium"),
                      ), //ButtonSegment(value: "2", label: Text("Medium")),
                      ButtonSegment(value: "3", label: Text("Heavy")),
                    ],
                    selected: _selectedFlow != null ? {_selectedFlow!} : {},
                    emptySelectionAllowed: true,
                    onSelectionChanged: _isPeriodDaySelected
                        ? (Set<String> newSelection) {
                            setState(() {
                              _selectedFlow = newSelection.isNotEmpty
                                  ? newSelection.first
                                  : null;
                            });
                          }
                        : null, // Disable selection if not a period day
                  ),
                  const SizedBox(height: 24),

                  // Symptoms Section
                  const Text("Symptoms",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: SymptomList.predefinedSymptoms.map((symptom) {
                      final isSelected = _selectedSymptoms.contains(symptom);

                      // Add emoji mapping for symptoms
                      final symptomEmojis = {
                        'Cramps': '🤕',
                        'Headache': '🤯',
                        'Bloating': '🫃',
                        'Fatigue': '😴',
                        'Breast Tenderness': '🤱',
                        'Back Pain': '🦴',
                        'Acne': '😶‍🌫️',
                        'Nausea': '🤢',
                        'Dizziness': '😵',
                        'Food Cravings': '🍫',
                        'Insomnia': '🌙',
                        'Muscle Pain': '💪',
                      };

                      return FilterChip(
                        label: Text('${symptomEmojis[symptom] ?? ''} $symptom'),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedSymptoms.add(symptom);
                            } else {
                              _selectedSymptoms.remove(symptom);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Moods Section
                  const Text("Moods",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: MoodList.predefinedMoods.map((mood) {
                      final isSelected = _selectedMoods.contains(mood);

                      // Add emoji mapping for moods
                      final moodEmojis = {
                        'Happy': '😊',
                        'Sad': '😢',
                        'Irritable': '😤',
                        'Anxious': '😨',
                        'Calm': '😌',
                        'Energetic': '⚡',
                        'Tired': '😴',
                        'Emotional': '😭',
                        'Motivated': '🚀',
                        'Stressed': '😰',
                        'Relaxed': '😌',
                        'Angry': '😡',
                        'Excited': '🤩',
                        'Disappointed': '😞',
                        'Confused': '😕',
                      };

                      return FilterChip(
                        label: Text('${moodEmojis[mood] ?? ''} $mood'),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedMoods.add(mood);
                            } else {
                              _selectedMoods.remove(mood);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Notes Section
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: "Notes",
                      hintText: "Add any additional notes here...",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  Center(
                    child: FilledButton.icon(
                      onPressed: _saveEntry,
                      icon: const Icon(Icons.save),
                      label: const Text("Save Entry"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveEntry() {
    if (_formKey.currentState!.validate()) {
      if (_isPeriodDaySelected) {
        final periodDay = PeriodDay(
          date: widget.focusedDay,
          flowWeight: _selectedFlow != null
              ? PeriodDay.flowWeightValues[int.parse(_selectedFlow!)]
              : FlowWeight.none,
          //TODO add validation for start and end days
          isPeriodStartDay: true,
          isPeriodEndDay: false,
          note: _notesController.text,
          listSymptoms: SymptomList(symptoms: _selectedSymptoms),
          listMoods: MoodList(moods: _selectedMoods),
        );
        DayEntryRepository.instance.insertPeriodDayEntry(periodDay);
      } else {
        DayEntryRepository.instance.deletePeriodDayEntry(widget.focusedDay);
        final day = Day(
          date: widget.focusedDay,
          isPeriodDay: _isPeriodDaySelected,
          note: _notesController.text,
          symptomList: SymptomList(symptoms: _selectedSymptoms),
          moodList: MoodList(moods: _selectedMoods),
        );
        DayEntryRepository.instance.insertDayEntry(day);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Entry saved successfully!")),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
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
