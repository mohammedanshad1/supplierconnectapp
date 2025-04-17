import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supplierconnectapp/model/login_model.dart';
import 'package:supplierconnectapp/model/supplier_model.dart';

class ApiService {
  static const String _baseUrl = 'https://flutter-api-sigma.vercel.app';

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
      throw Exception('Failed to login: ${response.reasonPhrase}');
    }
  }

  Future<List<SupplierModel>> getSuppliers(String token) async {
    print('Token being used: $token'); // Debug print
    final response = await http.get(
      Uri.parse('$_baseUrl/suppliers'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return supplierModelFromJson(response.body);
    } else {
      throw Exception('Failed to fetch suppliers: ${response.reasonPhrase}');
    }
  }
}
