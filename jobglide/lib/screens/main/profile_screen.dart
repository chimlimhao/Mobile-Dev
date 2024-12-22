import 'package:flutter/material.dart';
import 'package:jobglide/models/model.dart';
import 'package:jobglide/services/auth_service.dart';
import 'package:jobglide/screens/main/preferences_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.getCurrentUser();

    return Scaffold(
      body: ListView(
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                ],
              ),
            ),
            child: Column(
              children: [
                // Profile Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Text(
                    user.name[0],
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // User Name
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // User Email
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          // Profile Options
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.work_outline),
            title: const Text('Current Profession'),
            subtitle: Text(user.preferences.profession),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('Remote Work'),
            subtitle: Text(user.preferences.remoteOnly ? 'Remote Only' : 'On-site Available'),
            trailing: Icon(
              user.preferences.remoteOnly ? Icons.check_circle : Icons.circle_outlined,
              color: user.preferences.remoteOnly ? Colors.green : Colors.grey,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.business_center_outlined),
            title: const Text('Preferred Job Types'),
            subtitle: Text(
              user.preferences.preferredJobTypes
                  .map((t) => t.toString().split('.').last)
                  .join(', '),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.flash_on),
            title: const Text('Auto Apply'),
            subtitle: Text(
              user.autoApplyEnabled
                  ? 'Enabled - Jobs will be applied to automatically'
                  : 'Disabled - Jobs will be saved for review',
            ),
            trailing: Switch(
              value: user.autoApplyEnabled,
              onChanged: (value) {
                AuthService.setAutoApplyEnabled(value);
              },
            ),
          ),
          const Divider(),

          // Edit Preferences Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PreferencesScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              icon: const Icon(Icons.edit),
              label: const Text(
                'Edit Preferences',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
