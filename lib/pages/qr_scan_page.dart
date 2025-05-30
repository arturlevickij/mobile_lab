import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:my_project/services/usb_serial_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final usbService = UsbSerialService();

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  String scannedCode = 'Нічого не відскановано';

  Future<void> _handleScannedData(String code) async {
    try {
      final parts = code.split(',');
      final namePart = parts.firstWhere((p) => p.startsWith('name:'));
      final emailPart = parts.firstWhere((p) => p.startsWith('email:'));
      final passwordPart = parts.firstWhere((p) => p.startsWith('password:'));

      final name = namePart.split(':')[1].trim();
      final email = emailPart.split(':')[1].trim();
      final password = passwordPart.split(':')[1].trim();

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('name', name);
      await prefs.setString('email', email);
      await prefs.setString('password', password);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Профіль оновлено: $name')),
      );

      setState(() {
        scannedCode = code;
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Невірний формат QR-коду')),
      );
    }
  }

void _onDetect(BarcodeCapture capture) async {
  final barcodes = capture.barcodes;
  if (barcodes.isNotEmpty) {
    final String? code = barcodes.first.rawValue;
    if (code != null && code != scannedCode) {
      setState(() {
        scannedCode = code;
      });

      final parts = code.split(',');
      if (parts.length >= 3) {
        final email = parts[0].split(':').last.trim();
        final password = parts[1].split(':').last.trim();
        final name = parts[2].split(':').last.trim();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('password', password);
        await prefs.setString('name', name);

        final devices = await usbService.getDevices();
        if (devices.isNotEmpty) {
          final success = await usbService.connectToDevice(devices.first);
          if (success) {
            await usbService.sendData('$name,$email,$password\n');
            await usbService.disconnect();
          }
        }
      }
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сканування QR-коду')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: _onDetect,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Результат: $scannedCode'),
          ),
        ],
      ),
    );
  }
}
