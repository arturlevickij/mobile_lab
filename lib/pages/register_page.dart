import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/auth_cubit.dart';
import 'package:my_project/widgets/custom_button.dart';
import 'package:my_project/widgets/validated_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? emailError;
  String? passwordError;

  @override
  void dispose() {
    nameController.dispose();
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
    });
    return emailError == null && passwordError == null;
  }

  Future<void> _register() async {
    if (!_validateInputs()) return;

    final authCubit   = context.read<AuthCubit>();
    final navigator   = Navigator.of(context);
    final messenger   = ScaffoldMessenger.of(context);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name',     nameController.text.trim());
    await prefs.setString('email',    emailController.text.trim());
    await prefs.setString('password', passwordController.text.trim());

    await authCubit.logIn();

    messenger.showSnackBar(
      const SnackBar(content: Text('Реєстрація успішна!')),
    );

    navigator.pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Реєстрація')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Ім’я',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            CustomButton(
              text: 'Зареєструватися',
              onPressed: _register,
            ),
          ],
        ),
      ),
    );
  }
}
