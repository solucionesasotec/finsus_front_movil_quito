import 'package:bancamovil/core/models/clasif_credit.dart';
import 'package:bancamovil/core/models/clasif_credit_response.dart';
import 'package:bancamovil/core/models/type_credit.dart';
import 'package:bancamovil/core/models/type_credit_response.dart';
import 'package:bancamovil/core/services/clasif_credit_service.dart';
import 'package:bancamovil/core/services/type_credit_service.dart';
import 'package:flutter/material.dart';

class TypeCreditProvider with ChangeNotifier {
  final TypeCreditService _typeCreditService = TypeCreditService();
  bool _isLoading = false;
  late List<TypeCredit> _typeCredits = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<TypeCredit> get typeCredits => _typeCredits;
  String? get errorMessage => _errorMessage;

  Future<void> getTypeCredits() async {
    _isLoading = true;
    notifyListeners();

    try {
      TypeCreditResponse? typeCreditsResp =
          await _typeCreditService.getTypeCredits();
      if (typeCreditsResp != null) {
        if (typeCreditsResp.status == 1) {
          _typeCredits = typeCreditsResp.data;

          // Clasif credits service
          ClasifCreditService _clasifCreditService = ClasifCreditService();
          ClasifCreditResponse? clasifCreditResp =
              await _clasifCreditService.getClasifCredits();

          if (clasifCreditResp!=null) {
            if (clasifCreditResp.status == 1) {
              List<ClasifCredit> clasifCreditos = clasifCreditResp.data;
               List<int> idsCladifCred = clasifCreditos.map((object) => object.codTipoCredito).toList();
              _typeCredits = _typeCredits.where((object) => idsCladifCred.contains(object.codTipoCredito)).toList();
            }
          }

        } else {
          switch (typeCreditsResp.message) {
            case 'NO_RESULT':
              _errorMessage = 'No hay tipos de creditos';
              break;
            default:
              _errorMessage = 'Error desconocido: ${typeCreditsResp.message}';
          }
        }
      }
    } catch (e) {
      print("Error type credits provider: ${e}");
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo.';
    }

    _isLoading = false;
    notifyListeners();
  }
}
