import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/auth_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? name;
  String? email;
  String? password;
  bool _isPasswordVisible = false;
  List<Map<String, String>> profiles = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'Не вказано';
      email = prefs.getString('email') ?? 'Не вказано';
      password = prefs.getString('password') ?? '';
    });
  }

Future<void> _logout(BuildContext context) async {
  final navigator = Navigator.of(context);
  final authCubit = context.read<AuthCubit>();

  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Вийти з акаунту'),
      content: const Text('Ви впевнені, що хочете вийти?'),
      actions: [
        TextButton(
          onPressed: () => navigator.pop(false),
          child: const Text('Скасувати'),
        ),
        TextButton(
          onPressed: () => navigator.pop(true),
          child: const Text('Вийти'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    authCubit.logOut();
    navigator.pushNamedAndRemoveUntil('/', (route) => false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
            child: Icon(Icons.account_circle),
          ),
          const SizedBox(height: 16),
          Text('Ім’я: $name', style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          Text('Email: $email'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Пароль: ${_isPasswordVisible ? password : '••••••••'}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _logout(context),
            child: const Text('Вийти з акаунту'),
          ),
        ],
      ),
    );
  }
}
