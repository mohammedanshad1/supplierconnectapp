import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supplierconnectapp/model/supplier_model.dart';
import 'package:supplierconnectapp/service/api_service.dart';

class SupplierViewModel extends ChangeNotifier {
  final _apiService = ApiService();

  List<SupplierModel> _suppliers = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<SupplierModel> get suppliers => _suppliers;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchSuppliers() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Retrieve the token from shared_preferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print('Retrieved token: $token'); // Debug print
      if (token == null) {
        throw Exception('No token found');
      }

      _suppliers = await _apiService.getSuppliers(token);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
