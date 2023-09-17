import 'dart:convert';

List<Product> productFromJson(String str) {
  return List<Product>.from(
    json.decode(str).map(
          (x) {
        return Product.fromJson(json: x);
      },
    ),
  );
}

class Product {
  Product({
    this.id,
    this.name,
    this.image,
    this.quantity,
    required this.isSoldOut,
    required this.counterStart,
  });

  int? id;
  String? name;
  String? image;
  int? quantity;
  bool isSoldOut;
  bool counterStart;

  factory Product.fromJson({required Map<String, dynamic> json}) {
    return Product(
      id: json["id"],
      name: json["name"],
      image: json["image"],
      quantity: json["quantity"],
      isSoldOut: false,
      counterStart: false,
    );
  }
}