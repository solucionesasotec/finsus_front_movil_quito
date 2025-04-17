import 'package:bancamovil/core/models/comprobante_dep_responde.dart';
import 'package:bancamovil/core/services/comprobante_dep_service.dart';
import 'package:flutter/material.dart';

class ComprobanteDepProvider with ChangeNotifier {
  final ComprobanteDepService _comprDepService = ComprobanteDepService();
  bool _isLoading = false;
  late String? _txtEnvioMail;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get txtEnvioMail => _txtEnvioMail;
  String? get errorMessage => _errorMessage;

  Future<void> sendEmailComprobante() async {
    _isLoading = true;
    notifyListeners();

    try {
      ComprobanteDepReponse? comprobanteDepResp =
          await _comprDepService.sendEmailComprobante();
      if (comprobanteDepResp != null) {
        if (comprobanteDepResp.status == 1) {
          _txtEnvioMail = comprobanteDepResp.data;
        } else {
          switch (comprobanteDepResp.message) {
            case 'NO_RESULT':
              _errorMessage = 'Email no enviado';
              break;
            default:
              _errorMessage =
                  'Error desconocido: ${comprobanteDepResp.message}';
          }
        }
      }
    } catch (e) {
      print("Error send email comprob dep provider: ${e}");
      _errorMessage = 'Error en el servidor. Inténtalo de nuevo.';
    }

    _isLoading = false;
    notifyListeners();
  }
}
