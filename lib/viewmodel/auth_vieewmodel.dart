// File: lib/viewmodels/auth_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:supplierconnectapp/model/login_model.dart';
import 'package:supplierconnectapp/service/api_service.dart';

class AuthViewModel extends ChangeNotifier {
  final _apiService = ApiService();
  String? _token;
  
  String? get token => _token;
  
  Future<void> login(String username, String password) async {
    try {
      final loginResponse = await _apiService.login(username, password);
      _token = loginResponse.token;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
  
  void logout() {
    _token = null;
    notifyListeners();
  }
}