// To parse this JSON data, do
//
//     final supplierModel = supplierModelFromJson(jsonString);

import 'dart:convert';

List<SupplierModel> supplierModelFromJson(String str) => List<SupplierModel>.from(json.decode(str).map((x) => SupplierModel.fromJson(x)));

String supplierModelToJson(List<SupplierModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SupplierModel {
    int id;
    String name;

    SupplierModel({
        required this.id,
        required this.name,
    });

    factory SupplierModel.fromJson(Map<String, dynamic> json) => SupplierModel(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
