import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/auth_cubit.dart';
import 'package:my_project/cubit/usb_cubit.dart';
import 'package:my_project/pages/home_page.dart';
import 'package:my_project/pages/login_page.dart';
import 'package:my_project/pages/profile_page.dart';
import 'package:my_project/pages/qr_scan_page.dart';
import 'package:my_project/pages/register_page.dart';
import 'package:my_project/services/usb_serial_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final usbService = UsbSerialService();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UsbCubit(usbService)),
        BlocProvider(create: (_) => AuthCubit()..checkLoginStatus()),
      ],
      child: const SmartLampApp(),
    ),
  );
}

class SmartLampApp extends StatelessWidget {
  const SmartLampApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, bool>(
      builder: (context, isLoggedIn) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Smart Lamp',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: isLoggedIn ? const HomePage() : const LoginPage(),
          routes: {
            '/register': (context) => const RegisterPage(),
            '/profile': (context) => const ProfilePage(),
            '/qr': (context) => const QRScanPage(),
          },
        );
      },
    );
  }
}
