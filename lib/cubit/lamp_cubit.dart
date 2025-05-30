import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:my_project/services/usb_serial_service.dart';


class LampCubit extends Cubit<bool> {
  final UsbSerialService usbService;
  final logger = Logger();

  LampCubit({required this.usbService}) : super(false);

  Future<void> toggleLamp() async {
    final newState = !state;
    emit(newState);

    try {
      if (newState) {
        await usbService.sendData('ON');
      } else {
        await usbService.sendData('OFF');
      }
    } catch (e, stackTrace) {
      logger.e('Failed to send data', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> turnOn() async {
    emit(true);
    await usbService.sendData('ON');
  }

  Future<void> turnOff() async {
    emit(false);
    await usbService.sendData('OFF');
  }
}
