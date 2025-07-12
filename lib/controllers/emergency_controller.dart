import 'package:sos/commons.dart';

class EmergencyController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<List<EmergencyContact>> getEmergencyContacts() async {
    try {
      QuerySnapshot snapshot =
          await _firestore
              .collection('emergency_contacts')
              .orderBy('name')
              .get();
      return snapshot.docs
          .map(
            (doc) =>
                EmergencyContact.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      print('Error fetching emergency contacts: $e');
      return [];
    }
  }

  Future<void> saveEmergencyContact(EmergencyContact contact) async {
    try {
      await _firestore
          .collection('emergency_contacts')
          .doc(contact.id)
          .set(contact.toMap());
    } catch (e) {
      print('Error saving emergency contact: $e');
    }
  }

  Future<void> updateContactSelection(String contactId, bool isSelected) async {
    try {
      await _firestore.collection('emergency_contacts').doc(contactId).update({
        'isSelected': isSelected,
      });
    } catch (e) {
      print('Error updating contact selection: $e');
    }
  }

  Future<void> deleteEmergencyContact(String contactId) async {
    try {
      await _firestore.collection('emergency_contacts').doc(contactId).delete();
    } catch (e) {
      print('Error deleting emergency contact: $e');
    }
  }

  Future<void> triggerEmergencyAlert(EmergencyType emergencyType) async {
    try {
      List<EmergencyContact> selectedContacts = await getSelectedContacts();

      if (selectedContacts.isEmpty) {
        print('No emergency contacts selected.');
        return;
      }

      // Get current location first
      String locationInfo = await _getCurrentLocation();

      // Send SMS alerts with location
      await Future.wait([
        _sendSMSAlertsWithLocation(selectedContacts, emergencyType, locationInfo),
        _playEmergencySound(),
        _startVibration(),
        _logEmergencyEventWithLocation(emergencyType, locationInfo),
      ]);
    } catch (e) {
      print('Error triggering emergency alert: $e');
    }
  }

  Future<String> _getCurrentLocation() async {
    try {
      // Check and request location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        return 'Location unavailable (permissions denied)';
      }

      if (permission == LocationPermission.denied) {
        print('Location permissions denied');
        return 'Location unavailable (permissions denied)';
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );

      // Create Google Maps link
      String googleMapsLink = 'https://maps.google.com/?q=${position.latitude},${position.longitude}';
      
      return 'My location: $googleMapsLink\nCoordinates: ${position.latitude}, ${position.longitude}';
    } catch (e) {
      print('Error getting location: $e');
      return 'Location unavailable (error occurred)';
    }
  }

  Future<List<EmergencyContact>> getSelectedContacts() async {
    try {
      QuerySnapshot snapshot =
          await _firestore
              .collection('emergency_contacts')
              .where('isSelected', isEqualTo: true)
              .get();
      return snapshot.docs
          .map(
            (doc) =>
                EmergencyContact.fromMap(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      print('Error fetching selected contacts: $e');
      return [];
    }
  }

  Future<void> _sendWhatsAppAlertsWithLocation(
    List<EmergencyContact> contacts,
    EmergencyType emergencyType,
    String locationInfo,
  ) async {
    try {
      // Combine emergency message with location
      String fullMessage = '${emergencyType.emergencyMessage}\n\n$locationInfo';
      String encodedMessage = Uri.encodeComponent(fullMessage);

      for (EmergencyContact contact in contacts) {
        await _sendSingleWhatsAppMessage(contact, encodedMessage);
        // Shorter delay between contacts
        await Future.delayed(Duration(milliseconds: 500));
      }
    } catch (e) {
      print('Error sending WhatsApp alerts: $e');
    }
  }

  Future<void> _sendSMSAlertsWithLocation(
    List<EmergencyContact> contacts,
    EmergencyType emergencyType,
    String locationInfo,
  ) async {
    try {
      // Combine emergency message with location
      String fullMessage = '${emergencyType.emergencyMessage}\n\n$locationInfo';
      
      // Try to send automatic SMS first
      bool autoSMSSuccess = await _sendAutomaticSMS(contacts, fullMessage);
      
      if (!autoSMSSuccess) {
        // Fallback to SMS composer (requires user interaction)
        print('🔄 Automatic SMS failed, using SMS composer fallback');
        await _sendSMSViaComposer(contacts, fullMessage);
      }
    } catch (e) {
      print('Error sending SMS alerts: $e');
    }
  }

  Future<bool> _sendAutomaticSMS(
    List<EmergencyContact> contacts,
    String message,
  ) async {
    try {
      // This approach tries to send SMS without user interaction
      // Note: This requires SEND_SMS permission and may not work on all devices
      
      // First, check if we have SMS permission
      var smsPermission = await Permission.sms.status;
      if (!smsPermission.isGranted) {
        var result = await Permission.sms.request();
        if (!result.isGranted) {
          print('❌ SMS permission denied');
          return false;
        }
      }

      // Try to send SMS to multiple recipients at once
      List<String> phoneNumbers = contacts
          .map((contact) => _cleanPhoneNumber(contact.phoneNumber))
          .where((number) => number.isNotEmpty)
          .toList();
      
      if (phoneNumbers.isEmpty) {
        print('❌ No valid phone numbers found');
        return false;
      }

      // Create SMS URL with multiple recipients
      String recipients = phoneNumbers.join(';');
      String smsUrl = 'sms:$recipients?body=${Uri.encodeComponent(message)}';
      
      print('📱 Attempting to send SMS to ${phoneNumbers.length} contacts');
      print('📱 Recipients: $recipients');
      
      Uri uri = Uri.parse(smsUrl);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        print('✅ SMS composer opened with all contacts');
        return true;
      } else {
        print('❌ Cannot launch SMS composer');
        return false;
      }
    } catch (e) {
      print('❌ Error in automatic SMS: $e');
      return false;
    }
  }

  Future<void> _sendSMSViaComposer(
    List<EmergencyContact> contacts,
    String message,
  ) async {
    try {
      String encodedMessage = Uri.encodeComponent(message);

      for (EmergencyContact contact in contacts) {
        await _sendSingleSMSMessage(contact, encodedMessage);
        await Future.delayed(Duration(milliseconds: 300));
      }
    } catch (e) {
      print('Error sending SMS via composer: $e');
    }
  }

  Future<void> _sendSingleWhatsAppMessage(
    EmergencyContact contact,
    String encodedMessage,
  ) async {
    try {
      String cleanPhoneNumber = _cleanPhoneNumber(contact.phoneNumber);

      if (cleanPhoneNumber.isEmpty) {
        print('❌ Invalid phone number for ${contact.name}: ${contact.phoneNumber}');
        return;
      }

      print('📱 Sending WhatsApp to ${contact.name} (${cleanPhoneNumber})');

      // Try multiple WhatsApp URL formats
      List<String> whatsAppUrls = [
        'whatsapp://send?phone=$cleanPhoneNumber&text=$encodedMessage',
        'https://wa.me/$cleanPhoneNumber?text=$encodedMessage',
        'https://api.whatsapp.com/send?phone=$cleanPhoneNumber&text=$encodedMessage',
      ];

      bool success = false;
      
      for (String url in whatsAppUrls) {
        try {
          Uri uri = Uri.parse(url);
          
          if (await canLaunchUrl(uri)) {
            await launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );
            print('✅ WhatsApp opened for ${contact.name}');
            success = true;
            break;
          }
        } catch (e) {
          continue;
        }
      }

      if (!success) {
        print('❌ WhatsApp failed for ${contact.name}, trying SMS fallback');
        await _sendSingleSMSMessage(contact, encodedMessage);
      }

    } catch (e) {
      print('❌ Error sending WhatsApp to ${contact.name}: $e');
    }
  }

  Future<void> _sendSingleSMSMessage(
    EmergencyContact contact,
    String encodedMessage,
  ) async {
    try {
      String smsUrl = 'sms:${contact.phoneNumber}?body=$encodedMessage';
      Uri uri = Uri.parse(smsUrl);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        print('✅ SMS composer opened for ${contact.name}');
      } else {
        print('❌ Cannot open SMS for ${contact.name}');
      }
    } catch (e) {
      print('❌ SMS fallback failed for ${contact.name}: $e');
    }
  }



  String _cleanPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return '';

    String cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    if (cleaned.startsWith('+')) {
      cleaned = cleaned.substring(1);
    }

    // Handle Lebanese number formats
    if (cleaned.length == 8) {
      cleaned = '961$cleaned';
    } else if (cleaned.startsWith('0') && cleaned.length == 9) {
      cleaned = '961${cleaned.substring(1)}';
    } else if (cleaned.startsWith('961')) {
      // Already has country code
    } else if (cleaned.length == 10 && !cleaned.startsWith('961')) {
      cleaned = '961$cleaned';
    }

    // Validate final format
    if (cleaned.length >= 11 && cleaned.length <= 15 && cleaned.startsWith('961')) {
      return cleaned;
    }

    return '';
  }

  Future<void> _playEmergencySound() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('sounds/emergency_alert.mp3'));
    } catch (e) {
      print('Error playing emergency sound: $e');
    }
  }

  Future<void> _startVibration() async {
    try {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(pattern: [0, 500, 200, 500, 200, 500], repeat: 0);
      }
    } catch (e) {
      print('Error starting vibration: $e');
    }
  }

  Future<void> stopAlerts() async {
    try {
      await _audioPlayer.stop();
      await Vibration.cancel();
    } catch (e) {
      print('Error stopping alerts: $e');
    }
  }

  Future<void> _logEmergencyEventWithLocation(
    EmergencyType emergencyType,
    String locationInfo,
  ) async {
    try {
      await _firestore.collection('emergency_logs').add({
        'type': emergencyType.displayName,
        'timestamp': FieldValue.serverTimestamp(),
        'message': emergencyType.emergencyMessage,
        'location': locationInfo,
      });
    } catch (e) {
      print('Error logging emergency event: $e');
    }
  }



  // Method to prepare emergency message with location (for testing)
  Future<String> prepareEmergencyMessage(EmergencyType emergencyType) async {
    String locationInfo = await _getCurrentLocation();
    return '${emergencyType.emergencyMessage}\n\n$locationInfo';
  }
}