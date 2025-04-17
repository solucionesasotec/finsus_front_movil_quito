


import 'package:bancamovil/core/models/product.dart';

class ProductResponse {

  final int status;
  final String message;
  final List<Product> data;

  ProductResponse({required this.status, required this.message, required this.data});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List).map((a) => Product.fromJson(a)).toList(),
    );
  }
}