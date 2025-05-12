// lib/features/profile/presentation/widgets/profile_actions_card.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trade_verge/core/router/router.dart';
import 'package:go_router/go_router.dart';

class ProfileActionsCard extends StatelessWidget {
  const ProfileActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          _buildActionTile(
            context: context,
            icon: Icons.settings,
            title: 'Settings',
            onTap: () => context.push('/settings'),
          ),
          const Divider(height: 1),
          _buildActionTile(
            context: context,
            icon: Icons.help,
            title: 'Help & Support',
            onTap: () {
              // TODO: Implement help & support
            },
          ),
          const Divider(height: 1),
          _buildActionTile(
            context: context,
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            onTap: () {
              // TODO: Implement privacy policy
            },
          ),
          const Divider(height: 1),
          _buildActionTile(
            context: context,
            icon: Icons.logout,
            title: 'Logout',
            onTap: () async {
              await Supabase.instance.client.auth.signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
