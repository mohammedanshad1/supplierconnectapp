// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplierconnectapp/data/repository/auth_repository.dart';
import 'package:supplierconnectapp/domain/usecase/get_suppliers_usecase.dart';
import 'package:supplierconnectapp/domain/usecase/login_usecase.dart';
import 'package:supplierconnectapp/presentation/provider/auth_provider.dart';

import 'presentation/screens/login_screen.dart';

void main() {
  runApp(const SupplierConnectApp());
}

class SupplierConnectApp extends StatelessWidget {
  const SupplierConnectApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        Provider<LoginUseCase>(
          create: (context) => LoginUseCase(context.read<AuthRepository>()),
        ),
        Provider<GetSuppliersUseCase>(
          create: (context) =>
              GetSuppliersUseCase(context.read<AuthRepository>()),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            context.read<LoginUseCase>(),
            context.read<GetSuppliersUseCase>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Supplier Connect',
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
