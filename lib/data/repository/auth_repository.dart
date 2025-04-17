// lib/data/repositories/auth_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supplierconnectapp/data/models/supplier_models.dart';
import '../models/login_model.dart';

class AuthRepository {
  final String _baseUrl = 'https://flutter-api-sigma.vercel.app';

  Future<LoginModel> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return loginModelFromJson(response.body);
    } else {
      throw Exception('Failed to login');
    }
  }
  Future<List<SupplierModel>> getSuppliers() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/suppliers'),
      headers: {'Content-Type': 'application/json'},
    );

    print('Suppliers Response Status Code: ${response.statusCode}');
    print('Suppliers Response Data: ${response.body}');

    if (response.statusCode == 200) {
      return supplierModelListFromJson(response.body);
    } else {
      throw Exception('Failed to fetch suppliers');
    }
  }

}