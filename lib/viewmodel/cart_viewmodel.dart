import 'dart:convert';
import 'package:flutter/material.dart';
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
      _cartItems = cartItemsData.map((item) => CartItem.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> addToCart(CartItem item) async {
    final existingItemIndex = _cartItems.indexWhere((cartItem) => cartItem.productId == item.productId);
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
    final cartItemsJson = jsonEncode(_cartItems.map((item) => item.toJson()).toList());
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
}
