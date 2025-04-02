import 'package:flutter/material.dart';

class FeedbackView extends StatefulWidget {
  const FeedbackView({super.key});

  @override
  _FeedbackViewState createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers and variables
  String? _selectedProvince;
  DateTime? _selectedDate;
  final TextEditingController _surveyAdminController = TextEditingController();
  String? _selectedGender;
  final TextEditingController _ageController = TextEditingController();
  String? _selectedEducationLevel;
  String? _selectedIncomeSource;
  final List<String> _selectedProducts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Survey Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Province Dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Province",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: "Harare", child: Text("Harare")),
                    DropdownMenuItem(value: "Bulawayo", child: Text("Bulawayo")),
                    DropdownMenuItem(value: "Manicaland", child: Text("Manicaland")),
                    DropdownMenuItem(value: "Mashonaland Central", child: Text("Mashonaland Central")),
                    DropdownMenuItem(value: "Mashonaland East", child: Text("Mashonaland East")),
                    DropdownMenuItem(value: "Mashonaland West", child: Text("Mashonaland West")),
                    DropdownMenuItem(value: "Masvingo", child: Text("Masvingo")),
                    DropdownMenuItem(value: "Midlands", child: Text("Midlands")),
                    DropdownMenuItem(value: "Matabeleland North", child: Text("Matabeleland North")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedProvince = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Please select a province" : null,
                ),
                const SizedBox(height: 20),

                // Date Picker
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Date of Survey",
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: _selectedDate != null
                        ? _selectedDate!.toLocal().toString().split(' ')[0]
                        : '',
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Please select a date" : null,
                ),
                const SizedBox(height: 20),

                // Survey Admin Text Field
                TextFormField(
                  controller: _surveyAdminController,
                  decoration: const InputDecoration(
                    labelText: "Survey Admin",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Please enter the survey admin" : null,
                ),
                const SizedBox(height: 20),

                // Gender Radio Buttons
                const Text("Gender", style: TextStyle(fontSize: 16)),
                Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text("Male"),
                      value: "Male",
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text("Female"),
                      value: "Female",
                      groupValue: _selectedGender,
                      onChanged: (value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Age Text Field
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Age",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Please enter age" : null,
                ),
                const SizedBox(height: 20),

                // Education Level Dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Highest Level of Education",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: "No formal education",
                        child: Text("No formal education")),
                    DropdownMenuItem(
                        value: "Primary school", child: Text("Primary school")),
                    DropdownMenuItem(
                        value: "Secondary school",
                        child: Text("Secondary school")),
                    DropdownMenuItem(
                        value: "Tertiary education",
                        child: Text("Tertiary education")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedEducationLevel = value;
                    });
                  },
                  validator: (value) =>
                      value == null ? "Please select education level" : null,
                ),
                const SizedBox(height: 20),

                // Income Source Radio Buttons
                const Text("Main Source of Income",
                    style: TextStyle(fontSize: 16)),
                Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text("Farming"),
                      value: "Farming",
                      groupValue: _selectedIncomeSource,
                      onChanged: (value) {
                        setState(() {
                          _selectedIncomeSource = value;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text("Informal business"),
                      value: "Informal business",
                      groupValue: _selectedIncomeSource,
                      onChanged: (value) {
                        setState(() {
                          _selectedIncomeSource = value;
                        });
                      },
                    ),
                     RadioListTile<String>(
                      title: const Text("Formal employment"),
                      value: "Formal employment",
                      groupValue: _selectedIncomeSource,
                      onChanged: (value) {
                        setState(() {
                          _selectedIncomeSource = value;
                        });
                      },
                    ),
                     RadioListTile<String>(
                      title: const Text("Dependent on family"),
                      value: "Dependent on family",
                      groupValue: _selectedIncomeSource,
                      onChanged: (value) {
                        setState(() {
                          _selectedIncomeSource = value;
                        });
                      },
                    ),
                     RadioListTile<String>(
                      title: const Text("Other"),
                      value: "Other",
                      groupValue: _selectedIncomeSource,
                      onChanged: (value) {
                        setState(() {
                          _selectedIncomeSource = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const Text(
                  "What menstrual products do you currently use?",
                  style: TextStyle(fontSize: 16),
                ),
                Column(
                  children: [
                    CheckboxListTile(
                      title: const Text("Sanitary Pads"),
                      value: _selectedProducts.contains("Sanitary Pads"),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedProducts.add("Sanitary Pads");
                          } else {
                            _selectedProducts.remove("Sanitary Pads");
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("Tampons"),
                      value: _selectedProducts.contains("Tampons"),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedProducts.add("Tampons");
                          } else {
                            _selectedProducts.remove("Tampons");
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("Menstrual Cup"),
                      value: _selectedProducts.contains("Menstrual Cup"),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedProducts.add("Menstrual Cup");
                          } else {
                            _selectedProducts.remove("Menstrual Cup");
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("Cloth Pads"),
                      value: _selectedProducts.contains("Cloth Pads"),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedProducts.add("Cloth Pads");
                          } else {
                            _selectedProducts.remove("Cloth Pads");
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: const Text("Other"),
                      value: _selectedProducts.contains("Other"),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedProducts.add("Other");
                          } else {
                            _selectedProducts.remove("Other");
                          }
                        });
                      },
                    ),
                  ],
                ),
                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Handle form submission
                        print("Province: $_selectedProvince");
                        print("Date: $_selectedDate");
                        print("Survey Admin: ${_surveyAdminController.text}");
                        print("Gender: $_selectedGender");
                        print("Age: ${_ageController.text}");
                        print("Education Level: $_selectedEducationLevel");
                        print("Income Source: $_selectedIncomeSource");
                        print("Products: $_selectedProducts");

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Survey submitted!")),
                        );
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}