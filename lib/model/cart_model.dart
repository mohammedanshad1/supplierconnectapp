class CartItem {
  final int productId;
  final String productName;
  final double price;
  int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'productName': productName,
        'price': price,
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        productId: json['productId'],
        productName: json['productName'],
        price: json['price'],
        quantity: json['quantity'],
      );
}
