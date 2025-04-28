import 'package:flutter/material.dart';
import 'package:my_project/widgets/custom_button.dart';
import 'package:my_project/widgets/validated_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? loginError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    setState(() {
      emailError = 
      ValidatedTextField.validateEmail(emailController.text.trim());
      passwordError = 
      ValidatedTextField.validatePassword(passwordController.text.trim());
      loginError = null;
    });

    return emailError == null && passwordError == null;
  }

Future<void> _attemptLogin() async {
  if (!_validateInputs()) return;

  final prefs = await SharedPreferences.getInstance();
  final storedEmail = prefs.getString('email');
  final storedPassword = prefs.getString('password');

  if (storedEmail == null || storedPassword == null) {
    if (!mounted) return;
    setState(() {
      loginError = 'Користувач не зареєстрований';
    });
    return;
  }

  if (storedEmail == emailController.text.trim() &&
      storedPassword == passwordController.text.trim()) {
    await prefs.setBool('isLoggedIn', true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  } else {
    if (!mounted) return;
    setState(() {
      loginError = 'Неправильний email або пароль';
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Вхід'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValidatedTextField(
              label: 'Email',
              controller: emailController,
              errorText: emailError,
            ),
            const SizedBox(height: 16),
            ValidatedTextField(
              label: 'Пароль',
              controller: passwordController,
              isPassword: true,
              errorText: passwordError,
            ),
            if (loginError != null) ...[
              const SizedBox(height: 8),
              Text(
                loginError ?? '',
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 16),
            CustomButton(
              text: 'Увійти',
              onPressed: _attemptLogin,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Реєстрація'),
            ),
          ],
        ),
      ),
    );
  }
}
