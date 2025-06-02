import 'dart:developer' as dev;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/services/usb_serial_service.dart';
import 'package:usb_serial/usb_serial.dart';

part 'usb_state.dart';

class UsbCubit extends Cubit<UsbState> {
  final UsbSerialService usbService;

  UsbCubit(this.usbService) : super(UsbInitial());

  Future<void> connectToFirstAvailableDevice() async {
    emit(UsbConnecting());

    final devices = await usbService.getDevices();
    if (devices.isEmpty) {
      dev.log('[UsbCubit] No USB devices found.');
      emit(UsbDisconnected());
      return;
    }

    final success = await usbService.connectToDevice(devices.first);
    if (success) {
      emit(UsbConnected(device: devices.first));
    } else {
      dev.log(
        '[UsbCubit] Failed to connect to device: '
        '${devices.first.productName}',
      );
      emit(UsbDisconnected());
    }
  }

  Future<void> disconnect() async {
    await usbService.disconnect();
    emit(UsbDisconnected());
  }

  Future<void> send(String data) async {
    await usbService.sendData(data);
  }
}
