import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:mina_app/features/settings/view/settings_view.dart';
import 'package:mina_app/features/statistics/view/statistics_view.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = null; //FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.displayName ?? 'User'),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                (user?.displayName ?? 'U').substring(0, 1).toUpperCase(),
                style: const TextStyle(fontSize: 24.0),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Statistics'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StatisticsView()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsView()),
              );
            },
          ),
          const Divider(),
          ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap:
                  () {} /* async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pop(context); // Close drawer
              }
            }, */
              ),
        ],
      ),
    );
  }
}
