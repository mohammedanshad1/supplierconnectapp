// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplierconnectapp/view/login_view.dart';
import 'package:supplierconnectapp/view/splash_view.dart';
import 'package:supplierconnectapp/view/supplier_listscreen.dart';
import 'package:supplierconnectapp/viewmodel/login_viewmodel.dart';
import 'package:supplierconnectapp/viewmodel/supplier_viewmodel.dart';

void main() {
  runApp(const SupplierConnectApp());
}

class SupplierConnectApp extends StatelessWidget {
  const SupplierConnectApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => SupplierViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Supplier Connect',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/suppliers': (context) => const SupplierListScreen(),
        },
      ),
    );
  }
}
