import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../view_models/home_view_model.dart';
import '../view_models/theme_view_model.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

/// Settings view with glassmorphism design
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: Responsive.getPadding(context),
        children: [
          // Theme Toggle Section
          _buildSectionHeader('Appearance', theme),
          const SizedBox(height: 12),
          Consumer<ThemeViewModel>(
            builder: (context, themeViewModel, child) {
              return _buildThemeToggleCard(context, themeViewModel, theme, isDark);
            },
          ),
          const SizedBox(height: 32),

          // Data Management Section
          _buildSectionHeader('Data Management', theme),
          const SizedBox(height: 12),
          _buildSettingCard(
            context,
            'Clear Chat History',
            'Delete all your conversation history',
            Icons.delete_sweep,
            AppTheme.primaryRed,
            theme,
            () => _showClearHistoryDialog(context),
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            context,
            'Clear All Data',
            'Delete all app data including calculations',
            Icons.delete_forever,
            AppTheme.primaryRed,
            theme,
            () => _showClearAllDataDialog(context),
          ),

          const SizedBox(height: 32),

          // App Information Section
          _buildSectionHeader('App Information', theme),
          const SizedBox(height: 12),
          _buildSettingCard(
            context,
            'Share App',
            'Share this app with your friends',
            Icons.share,
            AppTheme.primaryBlue,
            theme,
            () => _shareApp(context),
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            'Version',
            '1.0.0',
            Icons.info_outline,
            AppTheme.primaryTeal,
            theme,
            isDark,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            'Developer',
            'Ran Vijay Kumar',
            Icons.person,
            AppTheme.primaryPink,
            theme,
            isDark,
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            'Email',
            'ranvijaykumar9708@gmail.com',
            Icons.email,
            AppTheme.primaryOrange,
            theme,
            isDark,
          ),

          const SizedBox(height: 32),

          // About Section
          _buildSectionHeader('About', theme),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.getGlassBackground(isDark),
                      AppTheme.getGlassBackground(isDark).withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppTheme.getGlassBorder(isDark),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Text(
                  'Loan Assistant is an AI-powered financial assistant that helps you make informed decisions about loans. Get instant advice, calculate EMIs, check eligibility, and manage your loan documents all in one place.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppTheme.getPrimaryGradient(),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggleCard(
    BuildContext context,
    ThemeViewModel themeViewModel,
    ThemeData theme,
    bool isDark,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryBlue.withOpacity(0.25),
                AppTheme.primaryPurple.withOpacity(0.15),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppTheme.primaryBlue.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  color: AppTheme.primaryBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Theme',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isDark ? 'Dark Mode' : 'Light Mode',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Switch(
                value: themeViewModel.isDarkMode,
                onChanged: (value) => themeViewModel.toggleTheme(),
                activeColor: AppTheme.primaryBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    ThemeData theme,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.25),
                  color.withOpacity(0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: color.withOpacity(0.4),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
    bool isDark,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.getGlassBackground(isDark),
                AppTheme.getGlassBackground(isDark).withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppTheme.getGlassBorder(isDark),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          title: Text(
            'Clear Chat History?',
            style: theme.textTheme.titleLarge,
          ),
          content: Text(
            'This will permanently delete all your chat history.',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                vm.clearAllHistory();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Chat history cleared'),
                    backgroundColor: AppTheme.primaryBlue,
                  ),
                );
              },
              child: Text(
                'Clear',
                style: TextStyle(color: AppTheme.primaryRed),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showClearAllDataDialog(BuildContext context) {
    final storageService = StorageService();
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          title: Text(
            'Clear All Data?',
            style: theme.textTheme.titleLarge,
          ),
          content: Text(
            'This will permanently delete all app data including chat history and calculations.',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await storageService.clearAllData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('All data cleared'),
                    backgroundColor: AppTheme.primaryBlue,
                  ),
                );
              },
              child: Text(
                'Clear',
                style: TextStyle(color: AppTheme.primaryRed),
              ),
            ),
          ],
        );
      },
    );
  }

  void _shareApp(BuildContext context) {
    Share.share(
      'Check out Loan Assistant - AI-Powered Financial Assistant! Get instant loan advice, calculate EMIs, and manage your loans all in one place.',
    );
  }
}

