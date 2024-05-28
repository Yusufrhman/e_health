import 'package:e_health/models/doctor.dart';
import 'package:intl/intl.dart';

enum AppointmentStatus { ongoing, completed, canceled }

class Appointment {
  Appointment({
    required this.id,
    required this.doctor,
    required this.schedule,
    required this.status,
    required this.userId,
    required this.rating
  });
  final String id;
  final Map<dynamic, dynamic> doctor;
  final DateTime schedule;
  final AppointmentStatus status;
  final String userId;
  final double rating;


  String get formattedDate {
    return DateFormat('yMd').format(schedule);
  }

  String get formattedTime {
    return DateFormat.Hm().format(schedule);
  }
}

AppointmentStatus getStatusFromString(String status) {
  try {
    return AppointmentStatus.values.firstWhere((e) => e.name == status);
  } catch (e) {
    throw Exception("Invalid category string: $status");
  }
}
