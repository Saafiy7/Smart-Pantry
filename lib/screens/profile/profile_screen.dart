import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Temporary values (saved with SharedPreferences later)
  final String _userName = 'Smart Pantry User';
  final String _userEmail = 'user@example.com';
  bool _notificationsEnabled = true;

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('About Smart Pantry'),
          content: const Text(
            'Smart Pantry helps you track the food in your kitchen, '
            'follow expiration dates and manage your shopping list.\n\n'
            'Version 1.0.0\n'
            'ISET Bizerte - DSI 3\n'
            'By Ahmed Wardi and Saafi Youssef',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.lightGreen,
                      child: Icon(
                        Icons.person,
                        size: 32,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userName,
                            style: textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _userEmail,
                            style: textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: 'Edit profile',
              icon: Icons.edit_outlined,
              isSecondary: true,
              onPressed: () {}, // not required in J1
            ),
            const SizedBox(height: 24),
            Text('Settings', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              clipBehavior: Clip.antiAlias,
              child: SwitchListTile(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                secondary: const Icon(Icons.notifications_outlined),
                title: const Text('Expiration alerts'),
                subtitle: Text(
                  'Get notified before products expire',
                  style: textTheme.bodySmall,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('About', style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Card(
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About Smart Pantry'),
                subtitle: Text('Version 1.0.0', style: textTheme.bodySmall),
                trailing: const Icon(Icons.chevron_right),
                onTap: _showAboutDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
