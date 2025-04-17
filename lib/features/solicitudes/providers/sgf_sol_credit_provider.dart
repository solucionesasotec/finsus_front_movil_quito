
import 'package:bancamovil/core/models/sgf_sol_credito.dart';
import 'package:bancamovil/core/models/sgf_sol_credito_response.dart';
import 'package:bancamovil/core/services/sgf_sol_credito_service.dart';
import 'package:flutter/material.dart';

class SgfSolCreditoProvider with ChangeNotifier {
  final SgfSolCreditoService _solCreditoService = SgfSolCreditoService();
  bool _isLoading = false;
  late SgfSolCredito? _solCredit;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  SgfSolCredito? get solCredit => _solCredit;
  String? get errorMessage => _errorMessage;

  Future<void> generateSolCredit(
    String cuenta,
    String capital,
    String tasa,
    String valinteres,
    String cuotas,
    String fechaprestamo,
    String fechavencimiento,
    String plazo,
    String fecvencimiento,
    String tipocredito,
    String clasifcredito,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      SgfSolCreditoResponse? solCreditResp = await _solCreditoService.generateSolCredit(cuenta, capital, tasa, valinteres, cuotas, fechaprestamo, fechavencimiento, plazo, fecvencimiento, tipocredito, clasifcredito);
      if (solCreditResp != null) {
        if (solCreditResp.status == 1) {
          _solCredit = solCreditResp.data;

        }
        if (solCreditResp.status == 0) {
          _solCredit = null;
          // msg: 'Ya existe' (socio con creditos vigentes)

        } else {
          switch (solCreditResp.message) {
            case 'NO_RESULT':
              _errorMessage = 'No hay instituciones financieras';
              break;
            default:
              _errorMessage = 'Error desconocido: ${solCreditResp.message}';
          }
        }
      }
    } catch (e) {
      print("Error Sol Credit provider: ${e}");
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo.';
    }

    _isLoading = false;
    notifyListeners();
  }

}
