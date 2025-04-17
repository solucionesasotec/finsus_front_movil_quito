// ignore_for_file: unused_field, avoid_print, unnecessary_brace_in_string_interps

import 'package:bancamovil/core/models/investments.dart';
import 'package:bancamovil/core/models/investments_response.dart';
import 'package:bancamovil/core/models/product.dart';
import 'package:bancamovil/core/models/product_response.dart';
import 'package:bancamovil/core/services/investment_service.dart';
import 'package:bancamovil/core/services/product_service.dart';
import 'package:flutter/material.dart';

class InvestmentsProvider with ChangeNotifier {
  final ProductService _productService = ProductService();
  final InvestmentService _investmentService = InvestmentService();
  bool _isLoading = false;
  late List<Investment> _investments = [];
  late String? _nomProdInversion = '';
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<Investment> get investments => _investments;
  String? get nomProdInversion => _nomProdInversion;
  String? get errorMessage => _errorMessage;

  Future<void> getInvestments() async {
    _isLoading = true;
    notifyListeners();

    try {
      InvestmentResponse? investmentsResp =
          await _investmentService.getInvestments();
      if (investmentsResp != null) {
        if (investmentsResp.status == 1) {
          _investments = investmentsResp.data;

          // Solo Vigentes
          _investments = _investments.where((investment) => investment.stsDeposito == 'V').toList();

        } else {
          switch (investmentsResp.message) {
            case 'NO_RESULT':
              _errorMessage = 'No tiene inversiones';
              break;
            default:
              _errorMessage = 'Error desconocido: ${investmentsResp.message}';
          }
        }
      }
    } catch (e) {
      print("Error investments provider: ${e}");
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo.';
      _investments = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}
