import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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
      
      // Vibrate the device
      // HapticFeedback.mediumImpact();
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Attendance marked successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(title: const Text('Attendance Scanner')),
      body: Stack(
        children: [
          // QR Scanner View
          if (_isScanning && !_attendanceMarked)
            MobileScanner(
              controller: _scannerController,
              onDetect: _onQRCodeDetected,
            ),
          
          // Success View
          if (_attendanceMarked)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 120,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Attendance Marked!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          
          // Scanner Controls
          if (!_attendanceMarked)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Torch Toggle
                  IconButton(
                    icon: _isTorchOn
                        ? const Icon(Icons.flash_on, color: Colors.white, size: 32)
                        : const Icon(Icons.flash_off, color: Colors.white, size: 32),
                    onPressed: () {
                      setState(() {
                        _isTorchOn = !_isTorchOn;
                        _scannerController.toggleTorch();
                      });
                    },
                  ),
                  
                  // Scan Again Button (shown only after successful scan)
                  if (_attendanceMarked)
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _attendanceMarked = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
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
        ],
      ),
    );
  }
}
