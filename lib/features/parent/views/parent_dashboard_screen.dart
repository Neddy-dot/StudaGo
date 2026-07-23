import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../attendance/models/attendance_model.dart';
import '../models/child_status_model.dart';
import '../viewmodels/parent_dashboard_viewmodel.dart';

class ParentDashboardScreen extends ConsumerWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(parentDashboardProvider);
    final viewModel = ref.read(parentDashboardProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.go('/login');
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: viewModel.refresh,
        child: _buildBody(context, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ParentDashboardState state) {
    if (state.isLoading && state.childStatus == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (state.childStatus == null) {
      return const Center(child: Text('Failed to load child data.'));
    }

    final childData = state.childStatus!;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildStatusCard(context, childData),
          const SizedBox(height: 24),
          
          if (childData.currentStatus == AttendanceStatus.boardedBus) ...[
             const Text(
              'Bus Tracking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildBusTracker(context, childData.busRoute),
            const SizedBox(height: 24),
          ],

          const Text(
            'Recent Notifications',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildNotificationLog(context, childData.notifications),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, ChildStatusModel childData) {
    String statusText = 'Unknown';
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.help_outline;

    switch (childData.currentStatus) {
      case AttendanceStatus.arrivedAtGate:
        statusText = 'In School';
        statusColor = Colors.green.shade600;
        statusIcon = Icons.school;
        break;
      case AttendanceStatus.exitedGate:
        statusText = 'Exited School Gate';
        statusColor = Colors.orange.shade600;
        statusIcon = Icons.directions_run;
        break;
      case AttendanceStatus.boardedBus:
        statusText = 'On Bus';
        statusColor = Colors.blue.shade600;
        statusIcon = Icons.directions_bus;
        break;
      case AttendanceStatus.alightedBus:
        statusText = 'Alighted Bus';
        statusColor = Colors.purple.shade600;
        statusIcon = Icons.hail;
        break;
      case AttendanceStatus.unknown:
        break;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: statusColor,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              childData.childName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Icon(statusIcon, size: 64, color: Colors.white),
            const SizedBox(height: 16),
            Text(
              statusText,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusTracker(BuildContext context, List<BusStop> route) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          children: route.asMap().entries.map((entry) {
            final index = entry.key;
            final stop = entry.value;
            final isLast = index == route.length - 1;

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: 48,
                    child: Column(
                      children: [
                        Icon(
                          Icons.circle,
                          color: stop.isPassed ? Colors.green : Colors.grey.shade400,
                          size: 20,
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 4,
                              color: stop.isPassed ? Colors.green : Colors.grey.shade300,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Text(
                        stop.locationName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: stop.isPassed ? FontWeight.bold : FontWeight.normal,
                          color: stop.isPassed ? Colors.black87 : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNotificationLog(BuildContext context, List<NotificationLog> notifications) {
    if (notifications.isEmpty) {
      return const Text('No recent notifications.');
    }

    final dateFormat = DateFormat('MMM d, h:mm a');

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final notif = notifications[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: const Icon(Icons.notifications, color: Colors.blue),
          ),
          title: Text(notif.message, style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(dateFormat.format(notif.timestamp)),
        );
      },
    );
  }
}
