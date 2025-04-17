// File: lib/viewmodels/supplier_viewmodel.dart
import 'package:flutter/material.dart';
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
  
  Future<void> fetchSuppliers(String token) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    
    try {
      _suppliers = await _apiService.getSuppliers(token);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
