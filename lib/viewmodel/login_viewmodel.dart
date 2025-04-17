// File: lib/viewmodels/login_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:supplierconnectapp/service/api_service.dart';

class LoginViewModel extends ChangeNotifier {
  final _apiService = ApiService();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';
  String _token = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get token => _token;

  Future<void> login(BuildContext context) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final loginModel = await _apiService.login(
        usernameController.text,
        passwordController.text,
      );

      _token = loginModel.token;

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login Successful!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate to supplier listar
      Navigator.pushReplacementNamed(context, '/suppliers');
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
