import 'package:flutter/material.dart';
import 'package:my_project/widgets/custom_button.dart';
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
    _loadProfiles();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'Не вказано';
      email = prefs.getString('email') ?? 'Не вказано';
      password = prefs.getString('password') ?? '';
    });
  }

  Future<void> _loadProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith('profile_'));
    setState(() {
      profiles = keys.map((key) {
        final data = prefs.getStringList(key) ?? [];
        return {
          'name': data.isNotEmpty ? data[0] : 'Не вказано',
          'email': data.length > 1 ? data[1] : 'Не вказано',
          'key': key,
        };
      }).toList();
    });
  }

  Future<void> _deleteProfile(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    _loadProfiles();
  }

Future<void> _logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLoggedIn', false);
  
  if (!mounted) return;
  Navigator.pushReplacementNamed(context, '/');
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
          CustomButton(
            text: 'Вийти',
            onPressed: _logout,
          ),
        ],
      ),
    );
  }
}
