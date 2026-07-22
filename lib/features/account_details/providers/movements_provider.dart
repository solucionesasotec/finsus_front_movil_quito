import 'package:bancamovil/core/models/movement.dart';
import 'package:bancamovil/core/models/movements_response.dart';
import 'package:bancamovil/core/services/movements_service.dart';
import 'package:flutter/material.dart';

class MovementsProvider with ChangeNotifier {
  final MovementsService _movementsService = MovementsService();
  bool _isLoading = false;
  List<Movement> _transactions = [];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<Movement> get transactions => _transactions;
  String? get errorMessage => _errorMessage;

  Future<void> getTransactions(
      String desde, String hasta, String producto, String cuenta) async {
    _isLoading = true;
    notifyListeners();

    try {
      MovementsResponse? movementsResp =
          await _movementsService.getMovements(desde, hasta, producto, cuenta);
      print("movementsResp: ${movementsResp}");
      if (movementsResp != null) {
        if (movementsResp.status == 1) {
          // _transactions = movementsResp.data;
          // Invertir movimientos
          _transactions = movementsResp.data.reversed.toList();
        } else {
          switch (movementsResp.message) {
            case 'NO_RESULT':
              _errorMessage = 'No hay movimientos';
              break;
            default:
              _errorMessage = 'Error desconocido: ${movementsResp.message}';
          }
        }
      }
    } catch (e) {
      print("Error provider al obtener transacciones 1: ${e}");
      _transactions = [];
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
