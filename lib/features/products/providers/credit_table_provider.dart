// ignore_for_file: unused_field, avoid_print, unnecessary_brace_in_string_interps

import 'package:bancamovil/core/models/credit_table.dart';
import 'package:bancamovil/core/models/credit_table_response.dart';
import 'package:bancamovil/core/services/credits_table_services.dart';
import 'package:flutter/material.dart';

class CreditTableProvider with ChangeNotifier {
  final CreditTableService _creditTableService = CreditTableService();
  bool _isLoading = false;
  late List<CreditTable> _creditTable = [];
  late double _saldoPendiente = 0.00;
  late int _cuotasPagadas = 0;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  List<CreditTable> get creditTable => _creditTable;
  double get saldoPendiente => _saldoPendiente;
  int get cuotasPagadas => _cuotasPagadas;
  String? get errorMessage => _errorMessage;

  Future<void> getCreditTable(String producto, String cuenta) async {
    _isLoading = true;
    notifyListeners();

    try {
      CreditTableResponse? creditTableResp =
          await _creditTableService.getCreditTable(producto, cuenta);
      if (creditTableResp != null) {
        if (creditTableResp.status == 1) {
          _creditTable = creditTableResp.data.reversed.toList();

          _creditTable = _creditTable.toList();
              // .where((cuota) =>
              //     (DateTime.parse(cuota.fecVencimiento).year <=
              //         DateTime.now().year) &&
              //     (DateTime.parse(cuota.fecVencimiento).month <=
              //         DateTime.now().month))
              // .toList();

          // Datos cabecera Credito
          _saldoPendiente = 0.00;
          _cuotasPagadas = 0;
          for (var i = 0; i < _creditTable.length; i++) {
            if (_creditTable[i].estado == 'PENDIENTE') {
              _saldoPendiente += (_creditTable[i].valSaldoCapital +
                  // _creditTable[i].valSaldoInteres +
                  // _creditTable[i].valSaldoMora +
                  double.parse(_creditTable[i].valSaldoInteres.toStringAsFixed(2)) +
                  double.parse(_creditTable[i].valSaldoMora.toStringAsFixed(2))  +
                  _creditTable[i].seguro);
            }
            // _saldoPendiente += _creditTable[i].valSaldoMora;
          }
          // for (var i = 0; i < _creditTable.length; i++) {
          //   if (_creditTable[i].estado == 'Pagado') {
          //     _cuotasPendientes++;
          //   }
          // }
          _cuotasPagadas = _creditTable.where((cuota) => cuota.estado == "Pagado").length;
        } else {
          switch (creditTableResp.message) {
            case 'NO_RESULT':
              _errorMessage = 'No tiene creditos';
              break;
            default:
              _errorMessage = 'Error desconocido: ${creditTableResp.message}';
          }
        }
      }
    } catch (e) {
      print("Error creditTable provider: ${e}");
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo.';
    }

    _isLoading = false;
    notifyListeners();
  }
}
