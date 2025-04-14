import 'package:flutter/foundation.dart';
import 'package:mina_app/data/model/user.dart';
import 'package:mina_app/data/database/databaseHelper.dart';

class UserRepository {
  UserRepository._privateConstructor();
  final UserRepository _instance = UserRepository._privateConstructor();
  UserRepository get instance => _instance;

  Future<void> insertOrUpdateUserSetting(String key, String value) async {
    try {
      await DatabaseHelper().insertOrUpdateUserSetting(key, value);
    } catch (e) {
      debugPrint('Error inserting or updating user setting: $e');
      rethrow;
    }
  }

  Future<String?> getUserSetting(String key) async {
    try {
      return await DatabaseHelper().getUserSetting(key);
    } catch (e) {
      debugPrint('Error fetching user setting: $e');
      return null;
    }
  }

  Future<Map<String, String>> getUserSettings() async {
    try {
      return await DatabaseHelper().getAllSettings();
    } catch (e) {
      debugPrint('Error fetching all user settings: $e');
      return {};
    }
  }
}
