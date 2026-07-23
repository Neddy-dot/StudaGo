import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attendance_model.dart';

class CheckInOutState {
  final bool isProcessing;
  final String? successMessage;
  final String? errorMessage;
  final String? lastScannedStudentId;
  final AttendanceStatus? lastAction;

  CheckInOutState({
    this.isProcessing = false,
    this.successMessage,
    this.errorMessage,
    this.lastScannedStudentId,
    this.lastAction,
  });

  CheckInOutState copyWith({
    bool? isProcessing,
    String? successMessage,
    String? errorMessage,
    String? lastScannedStudentId,
    AttendanceStatus? lastAction,
  }) {
    return CheckInOutState(
      isProcessing: isProcessing ?? this.isProcessing,
      successMessage: successMessage, // Intentional reset if not provided
      errorMessage: errorMessage,     // Intentional reset if not provided
      lastScannedStudentId: lastScannedStudentId ?? this.lastScannedStudentId,
      lastAction: lastAction ?? this.lastAction,
    );
  }
}

class CheckInOutViewModel extends Notifier<CheckInOutState> {
  @override
  CheckInOutState build() {
    return CheckInOutState();
  }

  void setScannedStudent(String studentId) {
    state = state.copyWith(lastScannedStudentId: studentId, successMessage: 'Scanned Student: $studentId');
  }

  Future<void> recordAttendance(AttendanceStatus status) async {
    if (state.lastScannedStudentId == null) {
      state = state.copyWith(errorMessage: 'Please scan a student barcode/QR first.');
      return;
    }

    state = state.copyWith(isProcessing: true, successMessage: null, errorMessage: null);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Mock success
    final actionName = status.toString().split('.').last;
    state = state.copyWith(
      isProcessing: false,
      successMessage: 'Successfully recorded: $actionName for student ${state.lastScannedStudentId}',
      lastAction: status,
      lastScannedStudentId: null, // Reset after successful action
    );
  }
  
  void clearMessages() {
    state = state.copyWith(successMessage: null, errorMessage: null);
  }
}

final checkInOutProvider = NotifierProvider<CheckInOutViewModel, CheckInOutState>(() {
  return CheckInOutViewModel();
});
