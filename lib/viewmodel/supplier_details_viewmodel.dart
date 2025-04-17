import 'package:flutter/material.dart';
import 'package:supplierconnectapp/model/supplier_detail_model.dart';
import 'package:supplierconnectapp/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupplierDetailViewModel extends ChangeNotifier {
  final int supplierId;
  final _apiService = ApiService();

  SupplierDetailModel? _supplierDetail;
  bool _isLoading = true;
  String _errorMessage = '';

  SupplierDetailModel? get supplierDetail => _supplierDetail;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  SupplierDetailViewModel({required this.supplierId}) {
    fetchSupplierDetails();
  }

  Future<void> fetchSupplierDetails() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        throw Exception('No token found');
      }

      final supplierDetail = await _apiService.getSupplierDetails(supplierId, token);
      _supplierDetail = supplierDetail;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
