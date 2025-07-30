import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../constants/app_colors.dart';
import '../widgets/nav_drawer.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _isScanning = true;
  bool _isTorchOn = false;
  bool _attendanceMarked = false;
  final MobileScannerController _scannerController = MobileScannerController(
    torchEnabled: false,
    facing: CameraFacing.back,
  );

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _onQRCodeDetected(BarcodeCapture capture) {
    if (!_attendanceMarked) {
      setState(() {
        _attendanceMarked = true;
      });
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Attendance marked successfully!'),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildScanOverlay() {
    return Center(
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.gold,
            width: 4,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            // Optional: Add a semi-transparent background outside the scan area
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text('Attendance Scanner'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // QR Scanner View
          if (_isScanning && !_attendanceMarked)
            Stack(
              children: [
                MobileScanner(
                  controller: _scannerController,
                  onDetect: _onQRCodeDetected,
                ),
                // Scan overlay
                _buildScanOverlay(),
              ],
            ),

          // Success View
          if (_attendanceMarked)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 120,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Attendance Marked!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _attendanceMarked = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                    label: const Text(
                      'Scan Again',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

          // Scanner Controls (only show when not marked)
          if (!_attendanceMarked)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Torch Toggle
                  IconButton(
                    icon: Icon(
                      _isTorchOn ? Icons.flash_on : Icons.flash_off,
                      color: _isTorchOn ? AppColors.gold : AppColors.textLight,
                      size: 32,
                    ),
                    onPressed: () {
                      setState(() {
                        _isTorchOn = !_isTorchOn;
                        _scannerController.toggleTorch();
                      });
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
