import 'dart:typed_data';

import 'package:usb_serial/usb_serial.dart';

class UsbSerialService {
  UsbPort? _port;

  Future<List<UsbDevice>> getDevices() async {
    return await UsbSerial.listDevices();
  }

  Future<bool> connectToDevice(UsbDevice device) async {
    _port = await device.create();
    if (!await _port!.open()) return false;

    await _port!.setDTR(true);
    await _port!.setRTS(true);
    await _port!.setPortParameters(9600, UsbPort.DATABITS_8,
        UsbPort.STOPBITS_1, UsbPort.PARITY_NONE,);

    return true;
  }

  Future<void> sendData(String data) async {
    if (_port != null) {
      await _port!.write(Uint8List.fromList(data.codeUnits));
    }
  }

  Future<void> disconnect() async {
    await _port?.close();
    _port = null;
  }
}
