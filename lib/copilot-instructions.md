
## Copilot Instructions

### Project Context
This is a menstrual cycle tracking application with the following core features:
- Period tracking and prediction
- Symptom and mood logging
- Calendar integration
- Data visualization
- Cloud sync and backup

### Code Style Guidelines
```dart
// Use this Dart/Flutter style:
class PeriodDay {
  final DateTime date;
  final int flowWeight;
  
  const PeriodDay({
    required this.date,
    this.flowWeight = 0,
  });

  // Prefer named constructors for complex initialization
  PeriodDay.fromJson(Map<String, dynamic> json) 
    : date = DateTime.parse(json['date']),
      flowWeight = json['flowWeight'];
}
```

### Common Patterns
1. **State Management**:
```dart
// BLoC pattern example
class CycleBloc extends Bloc<CycleEvent, CycleState> {
  final CycleRepository repository;
  
  CycleBloc(this.repository) : super(CycleInitial()) {
    on<PredictCycle>((event, emit) async {
      emit(CycleLoading());
      final prediction = await repository.predictNextCycle();
      emit(CyclePredicted(prediction));
    });
  }
}
```

### Code Generation Prompts
Use these clear prompts with Copilot:

1. For calendar integration:
```
"Create a Flutter calendar widget that shows period days with red indicators, 
fertile window with yellow, and allows tapping to add/edit entries."
```

2. For data visualization:
```
"Generate a symptoms frequency chart using Syncfusion Flutter Charts 
that shows a bar graph of symptom occurrences over the last 3 cycles."
```

### Anti-Patterns to Avoid
❌ Don't use global state management for user-specific data  
❌ Avoid direct database access from UI components  
❌ Don't hardcode color values - use Theme.of(context)  

### Testing Patterns
```dart
testWidgets('Calendar shows period days', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: CalendarPage(periodDays: [DateTime(2023, 1, 1)]),
  );
  expect(find.byWidgetPredicate((w) => w is CalendarDayMarker), findsNWidgets(1));
});
```

### Common Tasks
1. **Adding a new symptom type**:
   - Update Symptom enum
   - Add to SymptomLog repository
   - Update UI symptom picker widget

### Documentation Standards
```dart
/// Calculates the next predicted period date based on historical data.
/// [cycleHistory] - List of past complete cycles
/// Returns [DateTime] of predicted start or null if insufficient data
Future<DateTime?> predictNextCycle(List<Cycle> cycleHistory) async {
  // Implementation...
}
```

### Technical Architecture
1. **Data Layer**:
   - SQLite database for local storage
   - Cloud Firestore for cloud sync
   - JSON format for data exports

2. **Architecture**:
   - BLoC pattern for state management
   - Repository pattern for data access
   - MVVM architecture for UI components

3. **Dependencies**:
   - Flutter SDK
   - Firebase for authentication
   - Syncfusion Flutter Charts

## Troubleshooting Guide

### Database Migration Issues
1. Check db_version in sqflite initialization
2. Verify all new columns have default values
3. Test migration path with test_database.db

### BLoC State Not Updating
1. Verify emit() is being called
2. Check for missing yield statements in async*
3. Ensure EventTransformer is properly applied

### Notification Problems
1. Check FCM registration tokens
2. Verify notification permissions
3. Test on physical devices (not just simulators)
```

This comprehensive markdown file includes:
1. Complete project requirements (functional and non-functional)
2. Detailed Copilot instructions with code examples
3. Development patterns and anti-patterns
4. Testing guidelines
5. Architecture overview
6. Troubleshooting section

The document is organized hierarchically with clear section headings and uses consistent markdown formatting throughout. It serves as both a technical specification and development guide for the project.