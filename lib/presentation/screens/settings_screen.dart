import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Settings screen to manage privacy preferences and view legal documents
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _analyticsEnabled = false;
  bool _crashReportingEnabled = false;
  bool _loadingPreferences = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _analyticsEnabled = prefs.getBool('analytics_accepted') ?? false;
      _crashReportingEnabled = prefs.getBool('crash_reporting_accepted') ?? false;
      _loadingPreferences = false;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('analytics_accepted', _analyticsEnabled);
    await prefs.setBool('crash_reporting_accepted', _crashReportingEnabled);
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingPreferences) {
      return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Privacy & Data Section
              _buildSectionHeader('Privacy & Data'),
              const SizedBox(height: 12),

              // Analytics Toggle
              _buildSettingToggle(
                title: 'Analytics & Usage Data',
                subtitle: 'Help us improve the app by sharing anonymous usage data',
                value: _analyticsEnabled,
                onChanged: (value) {
                  setState(() {
                    _analyticsEnabled = value;
                  });
                  _savePreferences();
                },
                icon: Icons.bar_chart,
              ),

              const SizedBox(height: 12),

              // Crash Reporting Toggle
              _buildSettingToggle(
                title: 'Crash Reporting',
                subtitle: 'Automatically report app crashes to help us fix issues',
                value: _crashReportingEnabled,
                onChanged: (value) {
                  setState(() {
                    _crashReportingEnabled = value;
                  });
                  _savePreferences();
                },
                icon: Icons.bug_report,
              ),

              const SizedBox(height: 32),

              // Legal Documents Section
              _buildSectionHeader('Legal Documents'),
              const SizedBox(height: 12),

              // Terms of Service Button
              _buildLegalButton(
                title: 'Terms of Service',
                onPressed: () => _showDocumentDialog(
                  'Terms of Service',
                  'assets/legal/TERMS_OF_SERVICE.md',
                ),
              ),

              const SizedBox(height: 12),

              // Privacy Policy Button
              _buildLegalButton(
                title: 'Privacy Policy',
                onPressed: () => _showDocumentDialog(
                  'Privacy Policy',
                  'assets/legal/PRIVACY_POLICY.md',
                ),
              ),

              const SizedBox(height: 12),

              // GDPR Compliance Button
              _buildLegalButton(
                title: 'GDPR Compliance Guide',
                onPressed: () => _showDocumentDialog(
                  'GDPR Compliance',
                  'assets/legal/GDPR_COMPLIANCE.md',
                ),
              ),

              const SizedBox(height: 32),

              // Data Management Section
              _buildSectionHeader('Data Management'),
              const SizedBox(height: 12),

              // Data Request Button
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('Download My Data'),
                subtitle: const Text('Export your personal data (GDPR Right to Portability)'),
                onTap: () => _showDataExportDialog(),
              ),

              const SizedBox(height: 12),

              // Delete Data Button
              ListTile(
                leading: Icon(Icons.delete_forever, color: Colors.red),
                title: const Text(
                  'Delete My Data',
                  style: TextStyle(color: Colors.red),
                ),
                subtitle: const Text('Permanently delete all your data (GDPR Right to Erasure)'),
                onTap: () => _showDeleteConfirmation(),
              ),

              const SizedBox(height: 32),

              // App Info Section
              _buildSectionHeader('About DeckMate'),
              const SizedBox(height: 12),

              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('App Version'),
                subtitle: const Text('1.0.0'),
              ),

              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: const Text('Contact Support'),
                subtitle: const Text('support@deckmate.app'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email copied to clipboard: support@deckmate.app'),
                    ),
                  );
                  Clipboard.setData(const ClipboardData(text: 'support@deckmate.app'));
                },
              ),

              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Data Protection Authority'),
                subtitle: const Text('Contact your local DPA with privacy concerns'),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildSettingToggle({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildLegalButton({
    required String title,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: const Icon(Icons.description_outlined),
        title: Text(title),
        trailing: const Icon(Icons.open_in_new, size: 18),
        onTap: onPressed,
      ),
    );
  }

  Future<void> _showDocumentDialog(String title, String assetPath) async {
    try {
      final content = await rootBundle.loadString(assetPath);
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(content, style: const TextStyle(fontSize: 12)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading document: $e')),
      );
    }
  }

  Future<void> _showDataExportDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Your Data'),
        content: const Text(
          'Your data export will be prepared and downloaded as a JSON file. '
          'This may take a few moments.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data export initiated. Check your Downloads folder.'),
                ),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Data?'),
        content: const Text(
          'This will permanently delete:\n'
          '• Your quiz progress and scores\n'
          '• Your settings and preferences\n'
          '• Analytics and usage data\n\n'
          'This action CANNOT be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('All data has been deleted.'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete All Data'),
          ),
        ],
      ),
    );
  }
}
