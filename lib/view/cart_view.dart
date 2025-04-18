import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplierconnectapp/view/order_success_Screen.dart';
import 'package:supplierconnectapp/viewmodel/cart_viewmodel.dart';
import 'package:animate_do/animate_do.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

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
          'Cart',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        elevation: 0,
      ),
      body: Consumer<CartViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.cartItems.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.cartItems.length,
                  itemBuilder: (context, index) {
                    final cartItem = viewModel.cartItems[index];
                    return FadeInUp(
                      duration: const Duration(milliseconds: 300),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Icon(
                            Icons.shopping_bag,
                            color: Colors.blue.shade900,
                            size: 32,
                          ),
                          title: Text(
                            cartItem.productName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            'Price: \$${cartItem.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  viewModel.decreaseQuantity(index);
                                },
                              ),
                              Text(
                                '${cartItem.quantity}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  viewModel.increaseQuantity(index);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red.shade600,
                                ),
                                onPressed: () {
                                  String productName = cartItem.productName;
                                  viewModel.removeItem(index);
                                  final snackBar = SnackBar(
                                    elevation: 0,
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    content: AwesomeSnackbarContent(
                                      title: 'Item Removed',
                                      message:
                                          '$productName has been removed from your cart.',
                                      contentType: ContentType.warning,
                                      color: Colors.green.shade900,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(snackBar);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // viewModel.clearCart();
                          // final snackBar = SnackBar(
                          //   elevation: 0,
                          //   behavior: SnackBarBehavior.floating,
                          //   backgroundColor: Colors.transparent,
                          //   content: AwesomeSnackbarContent(
                          //     title: 'Cart Cleared',
                          //     message:
                          //         'All items have been removed from your cart.',
                          //     contentType: ContentType.help,
                          //     color: Colors.green.shade900,
                          //   ),
                          // );
                          // ScaffoldMessenger.of(context)
                          //   ..hideCurrentSnackBar()
                          //   ..showSnackBar(snackBar);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            bool orderSuccess = await viewModel.placeOrder();
                            if (orderSuccess) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const OrderSuccessScreen()),
                              );
                            }
                          } catch (e) {
                            final snackBar = SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Order Failed',
                                message: 'Failed to place order: $e',
                                contentType: ContentType.failure,
                                color: Colors.red.shade900,
                              ),
                            );
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Place Order',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
