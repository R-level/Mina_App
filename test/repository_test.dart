import 'package:mina_app/data/model/symptom_list.dart';
import 'package:mina_app/data/model/mood_list.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mina_app/data/repositories/day_entry_repository.dart';
import 'repository_test.mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mina_app/data/model/day.dart';

@GenerateMocks([DayEntryRepository])
void main() {
  group('DayEntryRepository Tests', () {
    late MockDayEntryRepository mockRepository;

    setUp(() {
      mockRepository = MockDayEntryRepository();
    });

//Test a day entry
    test('should insert a Day entry successfully', () async {
      // Arrange
      final day = Day(
        date: DateTime(2025, 4, 4),
        userId: 1,
        isPeriodDay: true,
        note: "Today was a fine day",
        symptomList: SymptomList(),
        moodList: MoodList(),
      );

      // Mock the behavior
      when(mockRepository.insertDayEntry(day))
          .thenAnswer((_) async => Future.value());

      // Act
      await mockRepository.insertDayEntry(day);

      // Assert
      verify(mockRepository.insertDayEntry(day)).called(1);
    });

//Test a day retrieval
    test('should retrieve a Day entry successfully', () async {
      final day = Day(
        date: DateTime(2025, 4, 4),
        isPeriodDay: true,
        note: "Today was a fine day",
        symptomList: SymptomList(),
        moodList: MoodList(),
      );

      // Mock the behavior of the getDayEntry method
      when(mockRepository.getDayEntry(day.date)).thenAnswer((_) async => day);

      // Call the method
      final result = await mockRepository.getDayEntry(day.date);

      // Verify the result
      expect(result, day);

      // Verify that the method was called with the correct arguments
      verify(mockRepository.getDayEntry(day.date)).called(1);
    });
  });
}
