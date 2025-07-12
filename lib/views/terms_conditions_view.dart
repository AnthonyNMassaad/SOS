import 'package:sos/commons.dart';

class TermsConditionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Terms & Conditions',
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
                        Icons.description,
                        color: Color(0xFF2C5F63),
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Terms of Service',
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
            _buildTermsSection(
              title: 'Acceptance of Terms',
              content:
                  'By using Health SOS, you agree to these terms and conditions. If you do not agree with any part of these terms, please do not use the application.',
            ),
            SizedBox(height: 16),
            _buildTermsSection(
              title: 'Emergency Services',
              content:
                  'Health SOS is designed to assist in contacting emergency services but does not replace direct emergency contact methods. Users should always contact emergency services directly when possible.',
            ),
            SizedBox(height: 16),
            _buildTermsSection(
              title: 'User Responsibilities',
              content:
                  'Users are responsible for maintaining accurate emergency contact information and ensuring their device has proper network connectivity. Misuse of emergency features may result in account suspension.',
            ),
            SizedBox(height: 16),
            _buildTermsSection(
              title: 'Limitation of Liability',
              content:
                  'Health SOS and its developers are not liable for any damages resulting from the use or inability to use the application. The app is provided "as is" without warranties of any kind.',
            ),
            SizedBox(height: 16),
            _buildTermsSection(
              title: 'Service Availability',
              content:
                  'We strive to maintain 24/7 service availability but cannot guarantee uninterrupted service. Maintenance, updates, or technical issues may temporarily affect functionality.',
            ),
            SizedBox(height: 16),
            _buildTermsSection(
              title: 'Modifications',
              content:
                  'These terms may be updated periodically. Users will be notified of significant changes through the application. Continued use constitutes acceptance of modified terms.',
            ),
            SizedBox(height: 16),
            _buildTermsSection(
              title: 'Contact Information',
              content:
                  'For questions regarding these terms, please contact us through the app support section or visit our GitHub repository for technical inquiries.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsSection({required String title, required String content}) {
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
