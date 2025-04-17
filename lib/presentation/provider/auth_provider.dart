// lib/presentation/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:supplierconnectapp/core/constants/app_strings.dart';
import 'package:supplierconnectapp/data/models/supplier_models.dart';
import 'package:supplierconnectapp/domain/usecase/get_suppliers_usecase.dart';
import 'package:supplierconnectapp/domain/usecase/login_usecase.dart';
import '../../data/models/login_model.dart';

class AuthProvider with ChangeNotifier {
  final LoginUseCase loginUseCase;
    final GetSuppliersUseCase getSuppliersUseCase;

  bool _isLoading = false;
  String? _errorMessage;
  LoginModel? _loginModel;
    List<SupplierModel> _suppliers = [];


  AuthProvider(this.loginUseCase, this.getSuppliersUseCase);

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LoginModel? get loginModel => _loginModel;
    List<SupplierModel> get suppliers => _suppliers;


  Future<void> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _loginModel = await loginUseCase.execute(username, password);
    } catch (e) {
      _errorMessage = AppStrings.loginError;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> fetchSuppliers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _suppliers = await getSuppliersUseCase.execute();
    } catch (e) {
      _errorMessage = 'Failed to fetch suppliers';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
