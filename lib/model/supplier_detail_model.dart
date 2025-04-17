// To parse this JSON data, do
//
//     final supplierDetailModel = supplierDetailModelFromJson(jsonString);

import 'dart:convert';

SupplierDetailModel supplierDetailModelFromJson(String str) => SupplierDetailModel.fromJson(json.decode(str));

String supplierDetailModelToJson(SupplierDetailModel data) => json.encode(data.toJson());

class SupplierDetailModel {
    int id;
    String name;
    List<Product> products;

    SupplierDetailModel({
        required this.id,
        required this.name,
        required this.products,
    });

    factory SupplierDetailModel.fromJson(Map<String, dynamic> json) => SupplierDetailModel(
        id: json["id"],
        name: json["name"],
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
    };
}

class Product {
    int id;
    String name;
    double price;

    Product({
        required this.id,
        required this.name,
        required this.price,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        price: json["price"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "price": price,
    };
}
