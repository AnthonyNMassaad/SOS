import 'package:sos/commons.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _notificationsEnabled = true;
  bool _locationServicesEnabled = true;
  bool _emergencyAlertsEnabled = true;
  bool _soundAlertsEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'Light';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF2C5F63),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSettingsSection(
            title: 'Emergency Settings',
            children: [
              _buildSwitchTile(
                title: 'Emergency Alerts',
                subtitle: 'Receive emergency notifications',
                value: _emergencyAlertsEnabled,
                onChanged:
                    (value) => setState(() => _emergencyAlertsEnabled = value),
                icon: Icons.warning_amber_rounded,
              ),
              _buildSwitchTile(
                title: 'Sound Alerts',
                subtitle: 'Play sound during emergencies',
                value: _soundAlertsEnabled,
                onChanged:
                    (value) => setState(() => _soundAlertsEnabled = value),
                icon: Icons.volume_up,
              ),
              _buildSwitchTile(
                title: 'Location Services',
                subtitle: 'Allow app to access your location',
                value: _locationServicesEnabled,
                onChanged:
                    (value) => setState(() => _locationServicesEnabled = value),
                icon: Icons.location_on,
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildSettingsSection(
            title: 'App Preferences',
            children: [
              _buildSwitchTile(
                title: 'Push Notifications',
                subtitle: 'Receive app notifications',
                value: _notificationsEnabled,
                onChanged:
                    (value) => setState(() => _notificationsEnabled = value),
                icon: Icons.notifications,
              ),
              _buildDropdownTile(
                title: 'Language',
                subtitle: 'App display language',
                value: _selectedLanguage,
                items: ['English', 'Arabic', 'French'],
                onChanged: (value) => setState(() => _selectedLanguage = value),
                icon: Icons.language,
              ),
              _buildDropdownTile(
                title: 'Theme',
                subtitle: 'App appearance',
                value: _selectedTheme,
                items: ['Light', 'Dark', 'System'],
                onChanged: (value) => setState(() => _selectedTheme = value),
                icon: Icons.palette,
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildSettingsSection(
            title: 'Support',
            children: [
              _buildActionTile(
                title: 'Emergency Contacts',
                subtitle: 'Manage emergency contacts',
                icon: Icons.contacts,
                onTap: () => Navigator.pushNamed(context, '/contacts'),
              ),
              _buildActionTile(
                title: 'Test Emergency Alert',
                subtitle: 'Test your emergency system',
                icon: Icons.bug_report,
                onTap: () => _showTestAlert(),
              ),
              _buildActionTile(
                title: 'Clear Data',
                subtitle: 'Reset app preferences',
                icon: Icons.delete_outline,
                onTap: () => _showClearDataDialog(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
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
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C5F63),
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Color(0xFF2C5F63).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Color(0xFF2C5F63), size: 22),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Color(0xFF2C5F63),
      ),
    );
  }

  Widget _buildDropdownTile({
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
    required IconData icon,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Color(0xFF2C5F63).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Color(0xFF2C5F63), size: 22),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            items:
                items
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
            onChanged: (newValue) => onChanged(newValue!),
            style: TextStyle(color: Color(0xFF2C5F63), fontSize: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Color(0xFF2C5F63).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Color(0xFF2C5F63), size: 22),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey.shade400,
      ),
      onTap: onTap,
    );
  }

  void _showTestAlert() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Test Alert'),
            content: Text('Emergency alert system is working properly!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Clear Data'),
            content: Text(
              'Are you sure you want to reset all app preferences? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('App preferences have been reset')),
                  );
                },
                child: Text('Clear', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
