import '../../attendance/models/attendance_model.dart';

class NotificationLog {
  final String message;
  final DateTime timestamp;

  NotificationLog({required this.message, required this.timestamp});
}

class BusStop {
  final String locationName;
  final bool isPassed;

  BusStop({required this.locationName, required this.isPassed});
}

class ChildStatusModel {
  final String childId;
  final String childName;
  final AttendanceStatus currentStatus;
  final List<BusStop> busRoute;
  final List<NotificationLog> notifications;

  ChildStatusModel({
    required this.childId,
    required this.childName,
    required this.currentStatus,
    this.busRoute = const [],
    this.notifications = const [],
  });
}
