import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mina_app/data/repositories/cycle_repository.dart';
import 'package:mina_app/data/database/databaseHelper.dart';
import 'package:mina_app/data/model/day.dart';
import 'package:mina_app/data/model/period_day.dart';
import 'package:mina_app/data/model/cycle.dart';

// Generate a mock class for DatabaseHelper
@GenerateMocks([DatabaseHelper])
import 'cycle_repository_test.mocks.dart';

void main() {
  late CycleRepository cycleRepository;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    cycleRepository = CycleRepository();
  });

  group('CycleRepository Tests', () {
    test('calculateCycleHistory should calculate cycles correctly', () async {
      // Arrange: Mock the database response
      when(mockDatabaseHelper.getCombinedDayAndPeriodDayRecords())
          .thenAnswer((_) async => [
                PeriodDay(
                  date: DateTime(2025, 4, 1),
                  isPeriodStartDay: true,
                  isPeriodEndDay: false,
                ),
                PeriodDay(
                  date: DateTime(2025, 4, 5),
                  isPeriodStartDay: false,
                  isPeriodEndDay: true,
                ),
                PeriodDay(
                  date: DateTime(2025, 4, 15),
                  isPeriodStartDay: true,
                  isPeriodEndDay: false,
                ),
                PeriodDay(
                  date: DateTime(2025, 4, 20),
                  isPeriodStartDay: false,
                  isPeriodEndDay: true,
                ),
              ]);

      // Act: Call the method
      List<Cycle> cyclesList = [];
      cyclesList = await cycleRepository.calculateCycleHistory();

      // Assert: Verify the results
      expect(cyclesList.length, 2); // Two cycles should be created
      expect(cyclesList[0].startDate, DateTime(2025, 4, 1));
      expect(cyclesList[0].endDate, DateTime(2025, 4, 4));
      expect(cyclesList[1].startDate, DateTime(2025, 4, 15));
      expect(cyclesList[1].endDate, DateTime(2025, 4, 19));
    });

    test('calculateAvgCycleLength should return correct average', () {
      // Arrange: Create a list of cycles
      List<Cycle> cyclesList = [
        Cycle(
            startDate: DateTime(2025, 4, 1),
            endDate: DateTime(2025, 4, 28),
            periodLength: 7),
        Cycle(
            startDate: DateTime(2025, 4, 29),
            endDate: DateTime(2025, 5, 20),
            periodLength: 5)
      ];

      // Act: Calculate the average cycle length
      final avgCycleLength = cycleRepository.calculateAvgCycleLength();

      // Assert: Verify the result
      expect(avgCycleLength, 5); // Average of 5 days
    });

    test('calculateAvgPeriodLength should return correct average', () async {
      // Arrange: Mock the database response
      when(mockDatabaseHelper.getCombinedDayAndPeriodDayRecords())
          .thenAnswer((_) async => [
                PeriodDay(
                  date: DateTime(2025, 4, 1),
                  isPeriodStartDay: true,
                  isPeriodEndDay: false,
                ),
                PeriodDay(
                  date: DateTime(2025, 4, 5),
                  isPeriodStartDay: false,
                  isPeriodEndDay: true,
                ),
                PeriodDay(
                  date: DateTime(2025, 4, 15),
                  isPeriodStartDay: true,
                  isPeriodEndDay: false,
                ),
                PeriodDay(
                  date: DateTime(2025, 4, 20),
                  isPeriodStartDay: false,
                  isPeriodEndDay: true,
                ),
              ]);

      // Act: Calculate the average period length
      final avgPeriodLength = await cycleRepository.calculateAvgPeriodLength();

      // Assert: Verify the result
      expect(avgPeriodLength, 5); // Average period length is 5 days
    });
  });
}
