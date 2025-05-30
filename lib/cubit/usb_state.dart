part of 'usb_cubit.dart';

abstract class UsbState {}

class UsbInitial extends UsbState {}

class UsbConnecting extends UsbState {}

class UsbConnected extends UsbState {
  final UsbDevice device;
  UsbConnected({required this.device});
}

class UsbDisconnected extends UsbState {}
