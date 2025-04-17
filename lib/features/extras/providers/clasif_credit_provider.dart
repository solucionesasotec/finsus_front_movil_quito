import 'package:bancamovil/core/models/clasif_credit.dart';
import 'package:bancamovil/core/models/clasif_credit_response.dart';
import 'package:bancamovil/core/services/clasif_credit_service.dart';
import 'package:flutter/material.dart';

class ClasifCreditProvider with ChangeNotifier {
  final ClasifCreditService _clasifCreditService = ClasifCreditService();
  bool _isLoading = false;
  late List<ClasifCredit> _clasifCredits = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<ClasifCredit> get clasifCredits => _clasifCredits;
  String? get errorMessage => _errorMessage;

  Future<void> getClasifCredits(int codClasifCredito) async {
    _isLoading = true;
    notifyListeners();

    try {
      ClasifCreditResponse? clasifCreditResp =
          await _clasifCreditService.getClasifCredits();
      if (clasifCreditResp != null) {
        if (clasifCreditResp.status == 1) {
          _clasifCredits = clasifCreditResp.data;
        
          _clasifCredits = _clasifCredits.where((object) => object.codTipoCredito == codClasifCredito).toList();

        } else {
          switch (clasifCreditResp.message) {
            case 'NO_RESULT':
              _errorMessage = 'No hay casificacion de creditos';
              break;
            default:
              _errorMessage = 'Error desconocido: ${clasifCreditResp.message}';
          }
        }
      }
    } catch (e) {
      print("Error clasif credits provider: ${e}");
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo.';
    }

    _isLoading = false;
    notifyListeners();
  }

  getOneClasifCredit(int codClasifCredit){
    ClasifCredit object = _clasifCredits.firstWhere((object) => object.codClasifCredito == codClasifCredit); 
    return object;
  }
}
