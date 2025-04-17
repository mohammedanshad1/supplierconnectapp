import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supplierconnectapp/model/cart_model.dart';

class CartViewModel extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  CartViewModel() {
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsJson = prefs.getString('cartItems');
    if (cartItemsJson != null) {
      final List<dynamic> cartItemsData = jsonDecode(cartItemsJson);
      _cartItems =
          cartItemsData.map((item) => CartItem.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> addToCart(CartItem item) async {
    final existingItemIndex = _cartItems
        .indexWhere((cartItem) => cartItem.productId == item.productId);
    if (existingItemIndex != -1) {
      _cartItems[existingItemIndex].quantity += item.quantity;
    } else {
      _cartItems.add(item);
    }
    notifyListeners();
    await _saveCartItems();
  }

  Future<void> _saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartItemsJson =
        jsonEncode(_cartItems.map((item) => item.toJson()).toList());
    await prefs.setString('cartItems', cartItemsJson);
  }

  void increaseQuantity(int index) {
    _cartItems[index].quantity++;
    notifyListeners();
    _saveCartItems();
  }

  void decreaseQuantity(int index) {
    if (_cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
      notifyListeners();
      _saveCartItems();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
    _saveCartItems();
  }

  Future<bool> placeOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.post(
      Uri.parse('https://flutter-api-sigma.vercel.app/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
      body: jsonEncode({
        'items': _cartItems
            .map((item) => {
                  'product_id': item.productId,
                  'quantity': item.quantity,
                  'price': item.price,
                })
            .toList(),
      }),
    );

    print(response.body);
    if (response.statusCode == 200) {
      clearCart();
      return true;
    } else {
      throw Exception('Failed to place order: ${response.reasonPhrase}');
    }
  }
}
