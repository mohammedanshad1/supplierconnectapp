import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supplierconnectapp/service/api_service.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart'; // Import the package

class LoginViewModel extends ChangeNotifier {
  final _apiService = ApiService();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> login(BuildContext context) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final loginModel = await _apiService.login(
        usernameController.text,
        passwordController.text,
      );

      // Save the token using shared_preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', loginModel.token);
      print('Stored token: ${loginModel.token}'); // Debug print

      // Show success snackbar using AwesomeSnackbarContent
      final successSnackBar = SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        content: AwesomeSnackbarContent(
          title: 'Login Successful!',
          message: 'Welcome to Supplier Connect!',
          contentType: ContentType.success,
          color: Colors.green.shade900, // Matches app theme
        ),
        duration: const Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(successSnackBar);

      // Navigate to supplier list
      Navigator.pushReplacementNamed(context, '/suppliers');
    } catch (e) {
      _errorMessage = e.toString();
      // Show error snackbar using AwesomeSnackbarContent
      final errorSnackBar = SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        content: AwesomeSnackbarContent(
          title: 'Login Failed!',
          message: _errorMessage,
          contentType: ContentType.failure,
          color: Colors.red.shade900, // Matches app theme
        ),
        duration: const Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(errorSnackBar);
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
