import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCubit extends Cubit<bool> {
  AuthCubit() : super(false);

  static const String _loginKey = 'isLoggedIn'; // Уникнення магічного рядка

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_loginKey) ?? false;
    emit(isLoggedIn);
  }

  Future<void> logIn() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, true);
    emit(true);
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, false);
    emit(false);
  }
}
