import 'package:flutter/material.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  bool _notificationsEnabled = true;
  bool _compactView = false;
  String _selectedDiet = 'None';

  final List<String> _dietaryOptions = [
    'None',
    'Vegetarian',
    'Vegan',
    'Gluten-Free',
    'Keto',
    'High-Protein',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Profile Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person_rounded,
                      size: 34,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ajith Kumar',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ajith@example.com',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    tooltip: 'Edit Profile',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile edit coming soon!')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Meal Planner Preferences
          Text(
            'Meal Planner Preferences',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.restaurant_rounded),
                  title: const Text('Dietary Preference'),
                  subtitle: Text(_selectedDiet),
                  trailing: DropdownButton<String>(
                    value: _selectedDiet,
                    underline: const SizedBox(),
                    items: _dietaryOptions.map((diet) {
                      return DropdownMenuItem<String>(
                        value: diet,
                        child: Text(diet),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedDiet = val);
                      }
                    },
                  ),
                ),
                const Divider(height: 1, indent: 56),
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined),
                  title: const Text('Meal Reminders'),
                  subtitle: const Text('Receive notifications for meal times'),
                  value: _notificationsEnabled,
                  onChanged: (val) => setState(() => _notificationsEnabled = val),
                ),
                const Divider(height: 1, indent: 56),
                SwitchListTile(
                  secondary: const Icon(Icons.view_compact_outlined),
                  title: const Text('Compact View'),
                  subtitle: const Text('Display smaller meal cards'),
                  value: _compactView,
                  onChanged: (val) => setState(() => _compactView = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // App Details
          Text(
            'App Information',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Column(
              children: [
                ListTile(
                  leading: Icon(Icons.apps_rounded),
                  title: Text('Application Name'),
                  trailing: Text(
                    'CcHelper',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(height: 1, indent: 56),
                ListTile(
                  leading: Icon(Icons.tag_rounded),
                  title: Text('Application ID'),
                  trailing: Text(
                    'com.mealplanner.cchelper',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                Divider(height: 1, indent: 56),
                ListTile(
                  leading: Icon(Icons.info_outline_rounded),
                  title: Text('Version'),
                  trailing: Text(
                    '1.0.0+2',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Sign out / data reset
          Center(
            child: TextButton.icon(
              icon: Icon(Icons.logout_rounded, color: theme.colorScheme.error),
              label: Text(
                'Log Out',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out')),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
