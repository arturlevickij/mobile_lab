import 'package:flutter/material.dart';

class MenuButtonWidget extends StatelessWidget {
  const MenuButtonWidget({super.key});

  void _onMenuSelected(BuildContext context, String value) {
    if (value == 'Exit') {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else {
      Navigator.pushNamed(context, '/${value.toLowerCase()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) => _onMenuSelected(context, value),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'Login', child: Text('Login')),
        const PopupMenuItem(value: 'Register', child: Text('Register')),
        const PopupMenuItem(value: 'Profile', child: Text('Profile')),
        const PopupMenuItem(value: 'Exit', child: Text('Exit')),
      ],
      icon: const Icon(Icons.menu),
    );
  }
}
