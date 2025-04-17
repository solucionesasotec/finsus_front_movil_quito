// ignore_for_file: unused_field, avoid_print, unnecessary_brace_in_string_interps

import 'package:bancamovil/core/models/garantia.dart';
import 'package:bancamovil/core/models/garantia_response.dart';
import 'package:bancamovil/core/services/garantia_service.dart';
import 'package:flutter/material.dart';

class GarantiaProvider with ChangeNotifier {
  final GarantiaService _garantiaService = GarantiaService();
  bool _isLoading = false;
  late List<Garantia> _garantias = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<Garantia> get garantias => _garantias;
  String? get errorMessage => _errorMessage;

  Future<void> getGarantias() async {
    _isLoading = true;
    notifyListeners();

    try {
      GarantiaResponse? garantiaResp = await _garantiaService.getGarantias();
      if (garantiaResp != null) {
        if (garantiaResp.status == 1) {
          _garantias = garantiaResp.data;

        } else {
          switch (garantiaResp.message) {
            case 'NO_RESULT':
              _errorMessage = 'No tiene garantias';
              break;
            default:
              _errorMessage = 'Error desconocido: ${garantiaResp.message}';
          }
        }
      }
    } catch (e) {
      print("Error garantias provider: ${e}");
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo.';
      _garantias = [];
    }

    _isLoading = false;
    notifyListeners();
  }




}
