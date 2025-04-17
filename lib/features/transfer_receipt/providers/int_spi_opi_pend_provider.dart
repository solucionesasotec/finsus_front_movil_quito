import 'package:bancamovil/core/models/int_spi_opi_pend.dart';
import 'package:bancamovil/core/models/int_spi_opi_pend_response.dart';
import 'package:bancamovil/core/services/int_spi_opi_pend_service.dart';
import 'package:flutter/material.dart';

class IntSpiOpiPendProvider with ChangeNotifier {
  final IntSpiOpiPendService _intSpiOpiPendService = IntSpiOpiPendService();
  bool _isLoading = false;
  late IntSpiOpiPend _intSpiOpiPend;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  IntSpiOpiPend get intSpiOpiPend => _intSpiOpiPend;
  String? get errorMessage => _errorMessage;

  Future<void> createDeposite(
      String productoenvia,
      String cuentaenvia,
      String producto,
      String cuenta,
      String banco,
      String monto,
      String comprobante) async {
    _isLoading = true;
    notifyListeners();

    try {
      IntSpiOpiPendResponse? depositeResp =
          await _intSpiOpiPendService.createDeposite(productoenvia, cuentaenvia,
              producto, cuenta, banco, monto, comprobante);
      if (depositeResp != null) {
        if (depositeResp.status == 1) {
          _intSpiOpiPend = depositeResp.data;
        } else {
          switch (depositeResp.message) {
            case 'NO_RESULT':
              _errorMessage = 'Deposito Spi Pend no creado';
              break;
            default:
              _errorMessage = 'Error desconocido: ${depositeResp.message}';
          }
        }
      }
    } catch (e) {
      print("Error create deposite provider: ${e}");
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo.';
    }

    _isLoading = false;
    notifyListeners();
  }
}
