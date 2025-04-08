import 'package:flutter/material.dart';

class ValidatedTextField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextEditingController controller;
  final String? errorText;

  const ValidatedTextField({
    required this.label, required this.controller, super.key,
    this.isPassword = false,
    this.errorText,
  });

  static String? validateEmail(String value) {
    if (value.isEmpty) return 'Email не може бути порожнім';
    if (!RegExp(r'^[\w.-]+@[a-zA-Z]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      return 'Невірний email';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) return 'Пароль не може бути порожнім';
    if (value.length < 6) return 'Мінімум 6 символів';
    return null;
  }

  @override
  State<ValidatedTextField> createState() => _ValidatedTextFieldState();
}

class _ValidatedTextFieldState extends State<ValidatedTextField> {
  bool _obscureText = true;
  String? _errorText;

  String? _validate(String value) {
    if (value.isEmpty) return 'Це поле є обовʼязковим';

    if (widget.label.toLowerCase().contains('email')) {
      if (!RegExp(r'^[\w.-]+@[a-zA-Z]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
        return 'Невірний email';
      }
    }

    if (widget.isPassword) {
      if (value.length < 6) return 'Пароль має містити щонайменше 6 символів';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword && _obscureText,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        errorText: _errorText,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : null,
      ),
      onChanged: (value) {
        setState(() {
          _errorText = _validate(value);
        });
      },
    );
  }
}
