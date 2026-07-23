enum AttendanceStatus {
  arrivedAtGate,
  exitedGate,
  boardedBus,
  alightedBus,
  unknown
}

class AttendanceModel {
  final String studentId;
  final AttendanceStatus status;
  final DateTime timestamp;

  AttendanceModel({
    required this.studentId,
    required this.status,
    required this.timestamp,
  });
}
