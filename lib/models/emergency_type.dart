import 'package:sos/commons.dart';

enum EmergencyType { suffocating, diabetes, accident, highBloodPressure }

extension EmergencyTypeExtension on EmergencyType {
  String get displayName {
    switch (this) {
      case EmergencyType.suffocating:
        return 'SUFFOCATING';
      case EmergencyType.diabetes:
        return 'DIABETES';
      case EmergencyType.accident:
        return 'INJURY / ACCIDENT';
      case EmergencyType.highBloodPressure:
        return 'HIGH BLOOD PRESSURE';
    }
  }

  String get emergencyMessage {
    switch (this) {
      case EmergencyType.suffocating:
        return 'EMERGENCY: I am suffocating, please help me immediately!';
      case EmergencyType.diabetes:
        return 'EMERGENCY: I am having a diabetic emergency, please assist me!';
      case EmergencyType.accident:
        return 'EMERGENCY: I am injured / had an accident, please help!';
      case EmergencyType.highBloodPressure:
        return 'EMERGENCY: My blood pressure is dangerously high, please assist!';
    }
  }

  Color get color {
    switch (this) {
      case EmergencyType.suffocating:
        return const Color(0xFFB00020); // deep red (critical breathing issue)
      case EmergencyType.diabetes:
        return const Color(0xFFFF9800); // orange (alert level)
      case EmergencyType.accident:
        return const Color(0xFF1565C0); // strong blue (trauma/calm authority)
      case EmergencyType.highBloodPressure:
        return const Color(0xFF6A1B9A); // deep purple (circulatory issues)
    }
  }
}
