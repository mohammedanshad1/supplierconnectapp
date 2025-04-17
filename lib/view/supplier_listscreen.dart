// File: lib/views/supplier_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplierconnectapp/viewmodel/supplier_viewmodel.dart';
 
class SupplierListScreen extends StatelessWidget {
  const SupplierListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SupplierViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
        backgroundColor: Colors.blue.shade900,
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.errorMessage.isNotEmpty
              ? Center(child: Text(viewModel.errorMessage))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: viewModel.suppliers.length,
                  itemBuilder: (context, index) {
                    final supplier = viewModel.suppliers[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            supplier.name[0],
                            style: TextStyle(color: Colors.blue.shade900),
                          ),
                        ),
                        title: Text(
                          supplier.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text('ID: ${supplier.id}'),
                      ),
                    );
                  },
                ),
    );
  }
}
