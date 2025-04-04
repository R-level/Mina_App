import 'package:flutter/material.dart';

class DayEntryView extends StatelessWidget {
  final DateTime focusedDay;
  const DayEntryView({super.key, required this.focusedDay});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    // Controllers for form fields
    final TextEditingController flowController = TextEditingController();
    final TextEditingController symptomsController = TextEditingController();
    final TextEditingController notesController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Period Tracker"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tracking for: ${focusedDay.toLocal()}".split(' ')[0],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // Flow Intensity Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Flow Intensity",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "Light", child: Text("Light")),
                  DropdownMenuItem(value: "Medium", child: Text("Medium")),
                  DropdownMenuItem(value: "Heavy", child: Text("Heavy")),
                ],
                onChanged: (value) {
                  flowController.text = value ?? "";
                },
                validator: (value) =>
                    value == null || value.isEmpty ? "Please select flow intensity" : null,
              ),
              const SizedBox(height: 20),
              // Symptoms Text Field
              TextFormField(
                controller: symptomsController,
                decoration: const InputDecoration(
                  labelText: "Symptoms",
                  hintText: "E.g., cramps, headache",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Please enter symptoms" : null,
              ),
              const SizedBox(height: 20),
              // Notes Text Field
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: "Notes",
                  hintText: "Additional notes",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Handle form submission
                      final flow = flowController.text;
                      final symptoms = symptomsController.text;
                      final notes = notesController.text;

                      // Example: Print the values to the console
                      print("Flow: $flow");
                      print("Symptoms: $symptoms");
                      print("Notes: $notes");

                      // Show a success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Entry saved successfully!")),
                      );
                    }
                  },
                  child: const Text("Save Entry"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}