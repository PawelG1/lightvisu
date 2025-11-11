import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Screen wymagany prawnie (EU/GDPR) - musi być pokazany przy pierwszym uruchomieniu
class TermsAndConditionsScreen extends StatefulWidget {
  final Function(bool accepted) onAccept;

  const TermsAndConditionsScreen({
    required this.onAccept,
    super.key,
  });

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  bool _acceptTerms = false;
  bool _acceptPrivacy = false;
  bool _acceptAnalytics = false;
  bool _showDetailedView = false;

  @override
  void initState() {
    super.initState();
    // Pre-check mandatory items (for UX - they'll still need to manually check)
    // This ensures visibility of requirements
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent back button
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to DeckMate'),
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _showDetailedView
                ? _buildDetailedView()
                : _buildMainView(),
          ),
        ),
      ),
    );
  }

  Widget _buildMainView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Privacy & Terms',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We respect your privacy. Before you continue, please review our policies.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // MANDATORY: Terms of Service
        _buildConsentItem(
          icon: Icons.description,
          title: 'Terms of Service',
          subtitle: 'REQUIRED - EU/Legal Compliance',
          value: _acceptTerms,
          onChanged: (val) => setState(() => _acceptTerms = val),
          required: true,
          summary:
              'Usage guidelines and liability disclaimers. Educational content only.',
        ),

        const SizedBox(height: 16),

        // MANDATORY: Privacy Policy
        _buildConsentItem(
          icon: Icons.privacy_tip,
          title: 'Privacy Policy & GDPR',
          subtitle: 'REQUIRED - EU/Legal Compliance',
          value: _acceptPrivacy,
          onChanged: (val) => setState(() => _acceptPrivacy = val),
          required: true,
          summary:
              'How we collect, use, and protect your data. GDPR compliant.',
        ),

        const SizedBox(height: 16),

        // OPTIONAL: Analytics
        _buildConsentItem(
          icon: Icons.bar_chart,
          title: 'Analytics & Crash Reporting',
          subtitle: 'OPTIONAL - Helps us improve the app',
          value: _acceptAnalytics,
          onChanged: (val) => setState(() => _acceptAnalytics = val),
          required: false,
          summary:
              'Anonymous usage data and error reports. You can change this anytime in Settings.',
        ),

        const SizedBox(height: 24),

        // Legal Info Box
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            border: Border.all(color: Colors.amber.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info, color: Colors.amber.shade800),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Important Legal Notice',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'DeckMate is an educational app for learning sailing rules. '
                'It does NOT replace official maritime certifications or training. '
                'Always consult official maritime authorities for critical decisions.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.amber.shade900,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // View Detailed Button
        SizedBox(
          width: double.infinity,
          child: TextButton.icon(
            icon: const Icon(Icons.open_in_new),
            label: const Text('View Full Documents'),
            onPressed: () => setState(() => _showDetailedView = true),
          ),
        ),

        const SizedBox(height: 16),

        // Accept Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _canProceed() ? _handleAccept : null,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('I Agree & Continue'),
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Decline Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _handleDecline,
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('Decline & Exit'),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Footer
        Center(
          child: Text(
            'You can change your preferences anytime in Settings',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Full Legal Documents',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => _showDetailedView = false),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildDocumentPreview(),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() => _showDetailedView = false),
            child: const Text('Back'),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentPreview() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              tabs: const [
                Tab(text: 'Terms'),
                Tab(text: 'Privacy'),
                Tab(text: 'GDPR'),
              ],
            ),
            SizedBox(
              height: 300,
              child: TabBarView(
                children: [
                  _buildDocumentTab('Terms of Service'),
                  _buildDocumentTab('Privacy Policy'),
                  _buildDocumentTab('GDPR Compliance'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentTab(String docName) {
    return FutureBuilder<String>(
      future: _loadLegalDocument(docName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading $docName'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(
            snapshot.data ?? 'Document not found',
            style: const TextStyle(fontSize: 12, height: 1.5),
          ),
        );
      },
    );
  }

  Widget _buildConsentItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required bool required,
    required String summary,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: value ? Colors.blue : Colors.grey.shade300,
            width: value ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: value ? Colors.blue.shade50 : Colors.transparent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: required ? Colors.red : Colors.amber,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: value,
                  onChanged: (val) => onChanged(val ?? false),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              summary,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    return _acceptTerms && _acceptPrivacy;
  }

  void _handleAccept() {
    // Zapisz preferencje
    _saveConsentPreferences();
    widget.onAccept(true);
  }

  void _handleDecline() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Decline Terms?'),
        content: const Text(
          'You must accept the Terms of Service and Privacy Policy to use DeckMate.\n\n'
          'The app will exit if you decline.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text('Exit App'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveConsentPreferences() async {
    // TODO: Implement with SharedPreferences or similar
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setBool('terms_accepted', _acceptTerms);
    // prefs.setBool('privacy_accepted', _acceptPrivacy);
    // prefs.setBool('analytics_accepted', _acceptAnalytics);
  }

  Future<String> _loadLegalDocument(String docName) async {
    try {
      String path = 'assets/legal/';
      switch (docName) {
        case 'Terms of Service':
          path += 'TERMS_OF_SERVICE.md';
          break;
        case 'Privacy Policy':
          path += 'PRIVACY_POLICY.md';
          break;
        case 'GDPR Compliance':
          path += 'GDPR_COMPLIANCE.md';
          break;
      }
      return await rootBundle.loadString(path);
    } catch (e) {
      return 'Unable to load document. Please check Settings.';
    }
  }
}
