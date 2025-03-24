import 'package:flutter/material.dart';
import 'package:my_project/widgets/background_widget.dart';
import 'package:my_project/widgets/custom_button.dart';
import 'package:my_project/widgets/custom_input.dart';
import 'package:my_project/widgets/menu_button_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: const MenuButtonWidget(),
      ),
      body: BackgroundWidget(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomInput(
                  label: 'Email',
                  controller: emailController,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter an email' : null,
                ),
                const SizedBox(height: 10),
                CustomInput(
                  label: 'Password',
                  isPassword: true,
                  controller: passwordController,
                  validator: (value) =>
                      value!.length < 6 ? 'Password too short' : null,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: 'Login',
                  onPressed: _submitForm,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
