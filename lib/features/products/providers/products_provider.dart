// ignore_for_file: unused_field, avoid_print, unnecessary_brace_in_string_interps

import 'package:bancamovil/core/models/product.dart';
import 'package:bancamovil/core/models/product_response.dart';
import 'package:bancamovil/core/services/product_service.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  bool _isLoading = false;
  late List<Product> _products = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<Product> get products => _products;
  String? get errorMessage => _errorMessage;

  Future<void> getProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      ProductResponse? productResp = await _productService.getProducts();
      if (productResp != null) {
        if (productResp.status == 1) {
          _products = productResp.data;

        } else {
          switch (productResp.message) {
            case 'NO_RESULT':
              _errorMessage = 'No tiene productos';
              break;
            default:
              _errorMessage = 'Error desconocido: ${productResp.message}';
          }
        }
      }
    } catch (e) {
      print("Error credits provider: ${e}");
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo.';
      _products = [];
    }

    _isLoading = false;
    notifyListeners();
  }




}
