import 'package:flutter/material.dart';
import 'package:mina_app/data/model/day.dart';
import 'package:mina_app/data/model/period_day.dart';
import 'package:mina_app/data/model/mood_list.dart';
import 'package:mina_app/data/model/symptom_list.dart';
import 'package:mina_app/data/repositories/day_entry_repository.dart';
import 'package:mina_app/features/day_entry/bloc/day_entry_bloc.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Day Entry"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Is Period Day?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Text(
                "Tracking for: ${widget.focusedDay.toLocal()}".split(' ')[0],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(children: [
                Switch(
                  value: _isPeriodDaySelected,
                  onChanged: (value) {
                    setState(() {
                      _isPeriodDaySelected = value;
                    });
                  },
                )
              ]),
              const SizedBox(height: 20),

              // Flow Intensity Section
              const Text("Flow Intensity",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: "0", label: Text("None")),
                  ButtonSegment(value: "1", label: Text("Light")),
                  ButtonSegment(value: "2", label: Text("Medium")),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: SymptomList.predefinedSymptoms.map((symptom) {
                  final isSelected = _selectedSymptoms.contains(symptom);
                  return FilterChip(
                    label: Text(symptom),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: MoodList.predefinedMoods.map((mood) {
                  final isSelected = _selectedMoods.contains(mood);
                  return FilterChip(
                    label: Text(mood),
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
    );
  }

  void _saveEntry() {
    if (_formKey.currentState!.validate()) {
      if (_isPeriodDaySelected) {
        final periodDay = PeriodDay(
          date: widget.focusedDay,
          flowWeight: PeriodDay.flowWeightValues[int.parse(_selectedFlow!)],
          isPeriodStartDay: true,
          isPeriodEndDay: false,
          note: _notesController.text,
          listSymptoms: SymptomList(symptoms: _selectedSymptoms),
          listMoods: MoodList(moods: _selectedMoods),
        );
        DayEntryRepository.instance.insertPeriodDayEntry(periodDay);
      } else {
        final day = Day(
          date: widget.focusedDay,
          isPeriodDay: _selectedFlow != null,
          note: _notesController.text,
          symptomList: SymptomList(symptoms: _selectedSymptoms),
          moodList: MoodList(moods: _selectedMoods),
        );
        DayEntryRepository.instance.insertDayEntry(day);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Entry saved successfully!")),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }
}
