import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/constants/spacing.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _soundAlerts = true;
  bool _locationTracking = true;
  bool _darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('PREFERENCES'),
        leading: IconButton(
          icon:  Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            _buildSectionHeader('SYSTEM'),
            _buildSwitchTile('Push Notifications', 'Receive job alerts', _pushNotifications, (val) => setState(() => _pushNotifications = val)),
            _buildSwitchTile('Sound Alerts', 'Play sound on new dispatch', _soundAlerts, (val) => setState(() => _soundAlerts = val)),
            _buildSwitchTile('Background Location', 'Required for job dispatch', _locationTracking, (val) => setState(() => _locationTracking = val)),
            
            SizedBox(height: AppSpacing.lg),
            _buildSectionHeader('APPEARANCE'),
            _buildSwitchTile('Dark Mode', 'Futuristic UI theme', _darkMode, (val) => setState(() => _darkMode = val)),
            
            SizedBox(height: AppSpacing.lg),
            _buildSectionHeader('ABOUT'),
            ListTile(
              title: Text('Version', style: AppTypography.bodyLarge),
              trailing: Text('1.0.0+1', style: AppTypography.bodyMedium),
            ),
            ListTile(
              title: Text('Terms & Conditions', style: AppTypography.bodyLarge),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
              onTap: () {},
            ),
            ListTile(
              title: Text('Privacy Policy', style: AppTypography.bodyLarge),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textSecondary),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm, top: AppSpacing.sm),
      child: Text(title, style: AppTypography.caption),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: AppTypography.bodyLarge),
      subtitle: Text(subtitle, style: AppTypography.caption),
      value: value,
      activeThumbColor: AppColors.primary,
      inactiveThumbColor: AppColors.textSecondary,
      inactiveTrackColor: AppColors.surfaceHighlight,
      onChanged: onChanged,
    );
  }
}
