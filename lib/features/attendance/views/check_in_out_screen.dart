import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attendance_model.dart';
import '../viewmodels/check_in_out_viewmodel.dart';

class CheckInOutScreen extends ConsumerWidget {
  const CheckInOutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkInOutProvider);
    final viewModel = ref.read(checkInOutProvider.notifier);

    // Listen to state changes to show snackbars for success/errors
    ref.listen<CheckInOutState>(checkInOutProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red.shade800,
            duration: const Duration(seconds: 2),
          ),
        );
        viewModel.clearMessages();
      } else if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: Colors.green.shade800,
            duration: const Duration(seconds: 2),
          ),
        );
        viewModel.clearMessages();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-In / Out'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Note: Ideally call authProvider logout and router pop here.
              // We'll leave this to the routing layer later.
            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Placeholder for Barcode / QR Scanner
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade400, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.qr_code_scanner, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'Camera Viewport Placeholder',
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Mock scanning a student
                        viewModel.setScannedStudent('STU-9981');
                      },
                      child: const Text('Mock Scan "John Doe"'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Mock scanning a student
                        viewModel.setScannedStudent('STU-1234');
                      },
                      child: const Text('Mock Scan "Jane Smith"'),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              if (state.scannedStudent != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Ready to log:',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${state.scannedStudent!.name} (${state.scannedStudent!.grade})',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

              const Divider(),
              const SizedBox(height: 8),
              
              const Text(
                'Select Action',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildActionButton(
                      context,
                      label: 'Arrived\nat Gate',
                      icon: Icons.school,
                      color: Colors.green.shade600,
                      isLoading: state.isProcessing,
                      onTap: () => viewModel.recordAttendance(AttendanceStatus.arrivedAtGate),
                    ),
                    _buildActionButton(
                      context,
                      label: 'Exited\nGate',
                      icon: Icons.directions_run,
                      color: Colors.orange.shade600,
                      isLoading: state.isProcessing,
                      onTap: () => viewModel.recordAttendance(AttendanceStatus.exitedGate),
                    ),
                    _buildActionButton(
                      context,
                      label: 'Boarded\nBus',
                      icon: Icons.directions_bus,
                      color: Colors.blue.shade600,
                      isLoading: state.isProcessing,
                      onTap: () => viewModel.recordAttendance(AttendanceStatus.boardedBus),
                    ),
                    _buildActionButton(
                      context,
                      label: 'Alighted\nBus',
                      icon: Icons.hail,
                      color: Colors.purple.shade600,
                      isLoading: state.isProcessing,
                      onTap: () => viewModel.recordAttendance(AttendanceStatus.alightedBus),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
