import 'package:flutter/material.dart';
import 'package:mina_app/data/database/databaseHelper.dart';
import 'package:mina_app/services/notification_service.dart';
import 'package:mina_app/services/backup_service.dart';
import 'package:mina_app/services/export_service.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final NotificationService _notificationService = NotificationService();
  final BackupService _backupService = BackupService();
  final ExportService _exportService = ExportService();

  bool _enableReminders = true;
  int _reminderDays = 2;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    try {
      final settings = await _dbHelper.getAllSettings();
      setState(() {
        _enableReminders = settings['enable_period_reminders'] == 'true';
        _reminderDays = int.parse(settings['reminder_days'] ?? '2');
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading settings: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _saveSettings() async {
    try {
      await _dbHelper.insertOrUpdateUserSetting(
          'enable_period_reminders', _enableReminders.toString());
      await _dbHelper.insertOrUpdateUserSetting(
          'reminder_days', _reminderDays.toString());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildNotificationSettings(),
                const Divider(),
                _buildBackupSettings(),
                const Divider(),
                _buildDataManagementSettings(),
              ],
            ),
    );
  }

  Widget _buildNotificationSettings() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Enable Period Reminders'),
            subtitle: const Text('Get notified before your next period'),
            value: _enableReminders,
            onChanged: (bool value) {
              setState(() => _enableReminders = value);
              _saveSettings();
            },
          ),
          ListTile(
            title: const Text('Reminder Days'),
            subtitle: Text('Notify $_reminderDays days before period'),
            trailing: DropdownButton<int>(
              value: _reminderDays,
              items: [1, 2, 3, 5, 7].map((days) {
                return DropdownMenuItem<int>(
                  value: days,
                  child: Text('$days days'),
                );
              }).toList(),
              onChanged: (int? value) {
                if (value != null) {
                  setState(() => _reminderDays = value);
                  _saveSettings();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackupSettings() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Backup & Restore',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.cloud_upload),
            title: const Text('Backup to Cloud'),
            subtitle: const Text('Save your data to your account'),
            onTap:
                () {} /*  async {
              try {
                await _backupService.backupToCloud();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Backup completed successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Backup failed: ${e.toString()}')),
                  );
                }
              }
            } */
            ,
          ),
          ListTile(
            leading: const Icon(Icons.save),
            title: const Text('Backup to Device'),
            subtitle: const Text('Save your data locally'),
            onTap: () async {
              try {
                await _backupService.backupToLocal();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Local backup completed')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Local backup failed: ${e.toString()}')),
                  );
                }
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Restore Data'),
            subtitle: const Text('Restore from backup'),
            onTap: () {} /* => _showRestoreDialog() */,
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagementSettings() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data Management',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.file_download),
            title: const Text('Export Data'),
            subtitle: const Text('Download your data as CSV'),
            onTap: () async {
              try {
                await _exportService.exportCycleData();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data exported successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Export failed: ${e.toString()}')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  /*  Future<void> _showRestoreDialog() async {
    try {
      final cloudBackups = await _backupService.getCloudBackups();
      final localBackups = await _backupService.getLocalBackups();

      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Restore Data'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                if (cloudBackups.isNotEmpty) ...[
                  const Text('Cloud Backups',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...cloudBackups.map((timestamp) => ListTile(
                        title: Text(timestamp),
                        onTap: () async {
                          Navigator.pop(context);
                          try {
                            await _backupService.restoreFromCloud(timestamp);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Restore completed successfully')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Restore failed: ${e.toString()}')),
                              );
                            }
                          }
                        },
                      )),
                ],
                if (localBackups.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text('Local Backups',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...localBackups.map((path) => ListTile(
                        title: Text(path.split('/').last),
                        onTap: () async {
                          Navigator.pop(context);
                          try {
                            await _backupService.restoreFromLocal(path);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Restore completed successfully')),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Restore failed: ${e.toString()}')),
                              );
                            }
                          }
                        },
                      )),
                ],
                if (cloudBackups.isEmpty && localBackups.isEmpty)
                  const Text('No backups available'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading backups: ${e.toString()}')),
        );
      }
    }
  }
 */
}
