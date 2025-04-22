/* import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; */
import 'package:mina_app/data/model/day.dart';
import 'package:mina_app/data/model/period_day.dart';
import 'package:mina_app/data/database/databaseHelper.dart';

/* class CloudSyncService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Upload local data to cloud
  Future<void> uploadData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Get all local data
      final days = await _dbHelper.getCombinedDayAndPeriodDayRecords();

      // Create batch write
      final batch = _firestore.batch();
      final userDoc = _firestore.collection('users').doc(user.uid);

      // Upload each day
      for (final day in days) {
        final dayDoc =
            userDoc.collection('days').doc(day.date.toIso8601String());
        batch.set(dayDoc, day.toMap(), SetOptions(merge: true));

        // If it's a period day, save additional data
        if (day is PeriodDay) {
          batch.set(dayDoc, day.toPeriodDayMap(), SetOptions(merge: true));
        }
      }

      // Commit the batch
      await batch.commit();
    } catch (e) {
      rethrow;
    }
  }

  // Download cloud data and merge with local
  Future<void> downloadData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Get all cloud data
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('days')
          .get();

      // Process each document
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final date = DateTime.parse(doc.id);

        // Create Day or PeriodDay object
        if (data['isPeriodDay'] == 1) {
          final periodDay = PeriodDay(
            date: date,
            flowWeight: data['flowWeight'],
            isPeriodStartDay: data['isPeriodStartDay'] == 1,
            isPeriodEndDay: data['isPeriodEndDay'] == 1,
            note: data['note'],
            listSymptoms: data['ListSymptoms'],
            listMoods: data['ListMoods'],
          );
          await _dbHelper.insertDay(periodDay);
        } else {
          final day = Day(
            date: date,
            isPeriodDay: data['isPeriodDay'] == 1,
            note: data['note'],
            symptomList: data['ListSymptoms'],
            moodList: data['ListMoods'],
          );
          await _dbHelper.insertDay(day);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  // Auto-sync functionality
  Future<void> autoSync() async {
    try {
      await uploadData();
      await downloadData();
    } catch (e) {
      rethrow;
    }
  }
}
 */
