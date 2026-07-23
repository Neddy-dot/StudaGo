import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/child_status_model.dart';
import '../../attendance/models/attendance_model.dart';

class ParentDashboardState {
  final bool isLoading;
  final ChildStatusModel? childStatus;
  
  ParentDashboardState({this.isLoading = false, this.childStatus});
  
  ParentDashboardState copyWith({bool? isLoading, ChildStatusModel? childStatus}) {
    return ParentDashboardState(
      isLoading: isLoading ?? this.isLoading,
      childStatus: childStatus ?? this.childStatus,
    );
  }
}

class ParentDashboardViewModel extends Notifier<ParentDashboardState> {
  @override
  ParentDashboardState build() {
    // Initial fetch
    _fetchMockData();
    return ParentDashboardState(isLoading: true);
  }

  Future<void> _fetchMockData() async {
    // Simulate network load
    await Future.delayed(const Duration(seconds: 1));
    
    final mockData = ChildStatusModel(
      childId: 'STU-9981',
      childName: 'Emma Watson',
      currentStatus: AttendanceStatus.boardedBus,
      busRoute: [
        BusStop(locationName: 'School Main Gate', isPassed: true),
        BusStop(locationName: 'Oakwood Drive', isPassed: true),
        BusStop(locationName: 'Pine Street Stop', isPassed: false),
        BusStop(locationName: 'Home (Maple Ave)', isPassed: false),
      ],
      notifications: [
        NotificationLog(
          message: 'Emma boarded School Bus #4', 
          timestamp: DateTime.now().subtract(const Duration(minutes: 15))
        ),
        NotificationLog(
          message: 'Emma exited the school gate', 
          timestamp: DateTime.now().subtract(const Duration(minutes: 17))
        ),
        NotificationLog(
          message: 'Emma arrived at school', 
          timestamp: DateTime.now().subtract(const Duration(hours: 7))
        ),
      ]
    );

    state = state.copyWith(isLoading: false, childStatus: mockData);
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await _fetchMockData();
  }
}

final parentDashboardProvider = NotifierProvider<ParentDashboardViewModel, ParentDashboardState>(() {
  return ParentDashboardViewModel();
});
