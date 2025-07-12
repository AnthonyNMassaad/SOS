import 'package:sos/commons.dart';

class PrivacyPolicyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF2C5F63),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.privacy_tip,
                        color: Color(0xFF2C5F63),
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Your Privacy Matters',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C5F63),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Last updated: ${DateTime.now().toString().split(' ')[0]}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            _buildPolicySection(
              title: 'Information We Collect',
              content:
                  'We collect location data during emergencies to dispatch help to your exact location. Emergency contact information is stored locally on your device for quick access during critical situations.',
            ),
            SizedBox(height: 16),
            _buildPolicySection(
              title: 'How We Use Your Information',
              content:
                  'Your information is used exclusively for emergency response purposes. Location data is shared with emergency services only when you activate an emergency alert. We do not sell or share your personal information with third parties for marketing purposes.',
            ),
            SizedBox(height: 16),
            _buildPolicySection(
              title: 'Data Security',
              content:
                  'We implement industry-standard security measures to protect your personal information. All emergency data is encrypted and transmitted securely. Your emergency contacts are stored locally on your device.',
            ),
            SizedBox(height: 16),
            _buildPolicySection(
              title: 'Data Retention',
              content:
                  'Emergency alert data is retained for 30 days for quality assurance and service improvement. You can request deletion of your data at any time through the app settings.',
            ),
            SizedBox(height: 16),
            _buildPolicySection(
              title: 'Your Rights',
              content:
                  'You have the right to access, modify, or delete your personal information. You can disable location services at any time, though this may affect emergency response capabilities.',
            ),
            SizedBox(height: 16),
            _buildPolicySection(
              title: 'Contact Us',
              content:
                  'If you have questions about this privacy policy or your data, please contact us through the app support section or visit our GitHub repository.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C5F63),
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
