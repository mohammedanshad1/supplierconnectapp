import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supplierconnectapp/view/cart_view.dart';
import 'package:supplierconnectapp/view/suppliers_details_view.dart';
import 'package:supplierconnectapp/viewmodel/supplier_details_viewmodel.dart';
import 'package:supplierconnectapp/viewmodel/supplier_viewmodel.dart';

class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({Key? key}) : super(key: key);

  @override
  _SupplierListScreenState createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<SupplierViewModel>(context, listen: false);
      viewModel.fetchSuppliers();
    });
  }

  Future<void> _refreshSuppliers() async {
    final viewModel = Provider.of<SupplierViewModel>(context, listen: false);
    await viewModel.fetchSuppliers();
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // Navigate to the login screen or perform any other logout action
    Navigator.pushReplacementNamed(context, '/');
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      _logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SupplierViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Suppliers',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshSuppliers,
        child: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : viewModel.errorMessage.isNotEmpty
                ? Center(child: Text(viewModel.errorMessage))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: viewModel.suppliers.length,
                    itemBuilder: (context, index) {
                      final supplier = viewModel.suppliers[index];
                      return AnimatedOpacity(
                        opacity: 1,
                        duration: const Duration(milliseconds: 500),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              radius: 28,
                              child: Text(
                                supplier.name[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              supplier.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              'ID: ${supplier.id}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.blue,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider(
                                    create: (_) => SupplierDetailViewModel(
                                        supplierId: supplier.id),
                                    child: SupplierDetailScreen(
                                        supplierId: supplier.id),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Suppliers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue.shade900,
        onTap: _onItemTapped,
      ),
    );
  }
}
