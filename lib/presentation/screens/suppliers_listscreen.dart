// lib/presentation/screens/supplier_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplierconnectapp/presentation/provider/auth_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import 'login_screen.dart';

class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({Key? key}) : super(key: key);

  @override
  _SupplierListScreenState createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).fetchSuppliers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.suppliersTitle),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            tooltip: AppStrings.logout,
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          if (authProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (authProvider.errorMessage != null) {
            return Center(child: Text(authProvider.errorMessage!));
          }

          if (authProvider.suppliers.isEmpty) {
            return const Center(child: Text(AppStrings.noSuppliers));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: authProvider.suppliers.length,
            itemBuilder: (context, index) {
              final supplier = authProvider.suppliers[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Text(
                      supplier.name[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    supplier.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    'ID: ${supplier.id}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
