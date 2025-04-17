import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplierconnectapp/viewmodel/supplier_details_viewmodel.dart';

class SupplierDetailScreen extends StatelessWidget {
  final int supplierId;

  const SupplierDetailScreen({Key? key, required this.supplierId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Supplier Food Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
      ),
      body: Consumer<SupplierDetailViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (viewModel.errorMessage.isNotEmpty) {
            return Center(child: Text(viewModel.errorMessage));
          } else {
            final supplier = viewModel.supplierDetail;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'supplier_${supplier!.id}',
                    child: Text(
                      supplier.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Products:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: supplier.products.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final product = supplier.products[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: const Icon(
                            Icons.shopping_bag,
                            color: Colors.blue,
                            size: 32,
                          ),
                          title: Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            'Price: \$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.add_shopping_cart,
                              color: Colors.blue,
                            ),
                            onPressed: () {
                              // Handle add to cart action
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('${product.name} added to cart'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
